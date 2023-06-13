#!/usr/bin/env python3
# -*-coding:utf-8-*-

import os
import argparse
import subprocess
import sys

parser = argparse.ArgumentParser(description="GWAS.py")
parser.add_argument('-v', '--vcf', required=True, help='the vcf file')
parser.add_argument('-t', '--trit', required=True, help='the trit file')
parser.add_argument('-p', '--pca', help='the num of pca', default = '3')
parser.add_argument('-i', '--imputation', help='whether do imputation, Y/N', default = 'N')
parser.add_argument('-o', '--outputpath', required=True, help='the output path, which end with /')
args = parser.parse_args()
def data_prepare():
    #print('__file__:    ', os.path.abspath(os.path.dirname(__file__)),'/trait.R')
    #print('getcwd:      ', os.getcwd())
    #sys.exit()
    WorkPath = os.path.abspath(args.outputpath)
    os.chdir(WorkPath)
    Rsc=os.path.abspath(os.path.dirname(__file__))+'/trait.R'
    trait = subprocess.Popen(["Rscript",Rsc,"-p", args.trit])
    trait.wait()
    print("Split trait successful!\n")
    vcf = os.path.abspath(args.vcf)
    DataPath = WorkPath
    # gt = PedPath + 'pop.KF.recode.vcf'
    #if os.path.exists('work_sh'):
    #    pass
    #else:
    #    os.mkdir('work_sh')
    #if os.path.exists('02.result'):
    #    pass
    #else:
    #    os.mkdir('02.result')
    #if os.path.exists('01.pre.data'):
     #   os.chdir('01.pre.data')
    #else:
    #    os.mkdir('01.pre.data')
    #os.chdir(WorkPath+'/01.pre.data')
    # genotype imputation
    if args.imputation == 'Y':
        beagle = subprocess.Popen(["java", "-jar", \
        "beagle.18May20.d20.jar",\
        "gt=%s"%vcf, "out=%s"%(DataPath+"pop.phased")])
        beagle.wait()
        print("genotype imputation Done!")
        gunzip = subprocess.Popen(["gunzip", "pop.phased.vcf.gz"])
        gunzip.wait()
        print("gunzip Done!")
        ped = subprocess.Popen(["vcftools", "--vcf", "pop.phased.vcf", "--plink", "--out", "pop"])
        ped.wait()
        print("vcf to ped Done!")
    else:
        ped = subprocess.Popen(["vcftools", "--vcf", vcf, "--plink", "--out", "pop"])
        ped.wait()
        print("vcf to ped Done!")
    #produce bed and tped file
    bed_file = subprocess.Popen(["plink", "--file", "pop", "--make-bed", "--out", "pop"])
    bed_file.wait()
    print("ped to bed Done!")
    tped_file = subprocess.Popen(\
    ["plink", "--file", "pop", "--recode12", "--output-missing-genotype", "0",\
    "--transpose", "--out", "pop"])
    #produce kinship matrix
    tped_file.wait()
    print("ped to tped Done!")
    grm_file = subprocess.Popen(\
    ["gcta", "--bfile", "pop", "--autosome", "--make-grm", "--out", "pop"])
    grm_file.wait()
    print("grm file had been calculate!")
    # gemma_kinship
    gemma_kin = subprocess.Popen(["gemma-0.98.1",\
            "-bfile", "pop", "-gk", "1", "-o", "pop", "-p", "pop.fam", "-maf", "0.05", "-miss", "0.4"])
    gemma_kin.wait()
    subprocess.Popen(['ln', '-s', 'output/pop.cXX.txt', './'])
    print('gemma_kin successful!')
    pca_file = subprocess.Popen(["gcta", "--grm", "pop", "--pca", args.pca, "--out", "pop.pca"])
    pca_file.wait()
    print("pca file had been calculate!")
    recodeA = subprocess.Popen(["plink", "--bfile", "pop", "--recodeA", "--out", "pop"])
    recodeA.wait()
    print("genotype to number was successful!")
    Kin_file = subprocess.Popen(\
    ["emmax-kin",\
    "-v", "-h", "-d", "10", "pop"])
    Kin_file.wait()
    print("emmax-kin was successful!")
if __name__ == '__main__':
    data_prepare()
