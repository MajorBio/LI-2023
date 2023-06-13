# count
rsem-prepare-reference --gtf genome.gtf genome.fa reference_name -p 8 
rsem-prepare-reference --transcript-to-gene-map g2t.txt --bowtie2 --bowtie2-path ./bioinfo/ref_rna_v3/bowtie2/miniconda3/bin/ -p 8 all_transcripts.fa ref_index   --bowtie2-k 10


