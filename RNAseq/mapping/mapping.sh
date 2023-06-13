
##mapping 

hisat = 'hisat2 -x {x} -p {p} -1 {r1} -2 {r2} ' \
            '{strand} ' \
            '--un-conc-gz {sample}/{sample}.unmapped.gz ' \
            '--novel-splicesite-outfile {sample}/splice.bed ' \
            '-S {sample}/{sample}.sam ' \
            '--dta'


