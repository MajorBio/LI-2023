#!/usr/bin/env python
# -*-coding:utf-8-*-

import os
import argparse
import subprocess

parser = argparse.ArgumentParser(description="GWAS.py")
parser.add_argument('-g', '--gff', required=True, help='the gff file')
parser.add_argument('-o', '--outpath', required=True, help='the output path, which end with /')
args = parser.parse_args()
def gff2geneloc():
    f = open(args.gff, 'r')
    fo = open(args.outpath + "geneloc.txt", "w")
    fo.writelines("geneid\tchr\tleft\tright\n")
    geneloc = []
    genes = []
    for line in f:
        Chr = line.strip().split('\t')[0] 
        loc1 = line.strip().split('\t')[3]
        loc2 = line.strip().split('\t')[4]
        geneid = line.strip().split('\t')[8].split(';')[1].split('=')[1]
        if int(loc1) < int(loc2):
            left = loc1
            right = loc2
        else:
            left = loc2
            right = loc1
        if geneid not in genes:
            genes.append(geneid)
            geneloc.append(geneid + '\t' + Chr + '\t' + left + '\t' + right + '\n')
    fo.writelines(i for i in geneloc)
    f.close()
    fo.close()

if __name__ == '__main__':
    gff2geneloc()
