# command line oneliners


convert csv to tab and vice versa
```
# comma -> tab
tr ',' '\t' < file

# tab -> comma
tr '\t' ',' < file
```

convert plink gwas output to single tab delimited
```
tr -s ' ' < gwas.assoc | sed 's/^ //g' | tr ' ' '\t' > gwas.assoc.tsv
```

number lines in a file
```
nl file
```

iterate across chromosomes
```
for chr in $(seq 1 22); do echo chromosome ${chr} ; done
```

number of unique lines in a file
```
cat file | sort -u | wc -l
```

reverse a file
```
tac file
```

concat multiple files and only include single header
```
grep -v 'header' files  | cat <(head -1 file1) -  > combined files
```

specific columns from tab separated file
```
cat file | cut -f1-10
```

remove header from a VCF
```
grep -v '^#' file.vcf
```


## AWK

print line number 1
```
awk '{if(NR == 1){print}}' < file
```

remove header
```
awk '{if(NR > 1){print}' < file
```


## GNU parallel 

compress and index all vcf files in a directory
```
parallel 'bgzip {} && tabix -p vcf {}.gz' ::: $(ls *vcf)
```

parallel gwas on all chromosomes
```
parallel 'plink --bfile chr{} --logisitic --out chr{} '  ::: $(seq 1 22)
```

create marker lists from vcf files
```
parallel 'zgrep -v "^#" file.chr{}.vcf.gz | cut -f1,2,4,5 > chr{}_markers.txt ' ::: $(seq 1 22)
```

## bashrc

To create log files of all commands used on a unix computer:

first make a directory for the logs
```
mkdir ~/.logs
```

then add this line into your ~/.bashrc file:
```
export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> ~/.logs/bash-history-$(date "+%Y-%m-%d").log; fi'
```

then either exit terminal and re-open or 

```
source ~/.bashrc
```
