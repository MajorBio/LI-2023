
## SNP and InDel CALLING

sentieon-genomics-202010 (https://support.sentieon.com/manual/)

sentieon driver -t 8 -r primary_assembly.fa -i TS_2.bam --algo LocusCollector --fun score_info TS_2.score.txt 
sentieon driver -t 8 -i TS_2.bam --algo Dedup --rmdup --score_info TS_2.score.txt --metric TS_2.metric.txt TS_2.dedup.bam
sentieon driver -t 8 -i TS_2.dedup.bam -r Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa --algo RNASplitReadsAtJunction --reassign_mapq 255:60 TS_2.splice.bam
sentieon driver -t 8 -i TS_2.splice.bam -r primary_assembly.fa --algo Haplotyper --trim_soft_clip --call_conf 20 --emit_conf 20 --emit_mode GVCF TS_2.g.vcf
