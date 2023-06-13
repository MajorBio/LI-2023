#!/usr/bin/env python3
# -*-coding:utf-8-*-

import os
import argparse
import subprocess

parser = argparse.ArgumentParser(description="GWAS.py")
parser.add_argument('-p', '--vcf', required=True, help='the dir for vcf, the end is /')
parser.add_argument('-c', '--pca', required=True, help='the dir for pca, the end is /')
parser.add_argument('-o', '--outputpath', required=True, help='the output path, which end with /')
parser.add_argument('-n', '--number', help='the number of pca for analysis', type = int, default = 5)
parser.add_argument('-t', '--threshold', help='the threshold for manhattan', type = float, default = 0.05)
parser.add_argument('-m', '--models', help='whether use mlmm or glmm, Y/N', default = 'N')
args = parser.parse_args()
def run():
    WorkPath = args.outputpath
    vcf = args.vcf
    DataPath = WorkPath + '01.pre.data/'
    TritPath = DataPath+'trit/'
    files = os.listdir(TritPath)
    # gt = PedPath + 'pop.KF.recode.vcf'
    os.chdir(WorkPath)
    if os.path.exists('work_sh'):
        pass
    else:
        os.mkdir('work_sh')
    if os.path.exists('02.result'):
        pass
    else:
        os.mkdir('02.result')
    if os.path.exists('01.pre.data'):
        os.chdir('01.pre.data')
    else:
        os.mkdir('01.pre.data')
        os.chdir('01.pre.data')
    # genotype imputation
    # beagle = subprocess.Popen(["java", "-jar", \
    # "/mnt/ilustre/centos7users/xiaolong.he/bin/beagle/beagle.18May20.d20.jar",\
    # "gt=%s"%gt, "out=%s"%(DataPath+"pop.phased")])
    # beagle.wait()
    # print("beagle Done!")
    # gunzip = subprocess.Popen(["gunzip", "pop.phased.vcf.gz"])
    # gunzip.wait()
    # print("gunzip Done!")
    ped = subprocess.Popen(["vcftools", "--vcf", vcf, "--plink",\
    "--out", "pop"])
    ped.wait()
    print("vcf to ped Done!")
    #produce bed and tped file
    bed_file = subprocess.Popen(\
    ["plink", "--file", "pop", "--make-bed", "--out", "pop"])
    bed_file.wait()
    print("ped to bed Done!")
    tped_file = subprocess.Popen(\
    ["plink", "--file", "pop", "--recode12", "--output-missing-genotype", "0",\
    "--transpose", "--out", "pop"])
    #produce kinship matrix
    tped_file.wait()
    print("ped to tped Done!")
    grm_file = subprocess.Popen(\
    ["gcta64", "--bfile", "pop", "--autosome", "--make-grm-gz", "--out", "pop"])
    grm_file.wait()
    print("grm file had been calculate!")
    recodeA = subprocess.Popen(["plink", "--bfile", "pop", "--recodeA", "--out", "pop"])
    recodeA.wait()
    print("genotype to number was successful!")
    Kin_file = subprocess.Popen(\
    ["/mnt/ilustre/centos7users/xiaolong.he/bin/modle/EMMAX/emmax-beta-07Mar2010/emmax-kin",\
    "-v", "-h", "-d", "10", "pop"])
    Kin_file.wait()
    print("emmax-kin was successful!")
    #get pheno file and create catalog
    for fi in files:
        os.chdir(WorkPath)
        typ = fi.strip().split('.')[-1]
        if typ == 'trt':
            name = fi.strip().split('.')[0]
            os.chdir('work_sh')
            #get the absolute path of pca,pheno and R work path
            pca = DataPath + 'pop.pca.eigenvec'
            pheno = TritPath+fi
            kinship = WorkPath+'01.pre.data/pop.grm.gz'
            bed = WorkPath+'01.pre.data/pop'
            sh_name = name+'.sh'
            f = open(sh_name,'w')
            f.writelines('#!/bin/bash\n' + \
            'cd %s'%(WorkPath + '02.result/' + name) + '&&' + 'Rscript' + ' ' +\
            '/mnt/ilustre/centos7users/xiaolong.he/develop/GWAS/scripts/GWAS.R ' +\
            '-p %s -c %s -k %s -b %s -o %s -n %s -m %s -s %s'%\
            (pheno, pca, kinship, bed, name, args.number, args.models, args.threshold))
            f.close()
            os.chdir(WorkPath+'02.result')
            if os.path.exists(name):
                pass
            else:
                os.mkdir(name)
                os.chdir(name)
            run_sh = WorkPath+'work_sh/'+sh_name
            rscrip = subprocess.Popen(['sh', run_sh])
            rscrip.wait()
            print(name + ' ' + 'was successful!')
            print("*"*20)
if __name__ == '__main__':
    run()
