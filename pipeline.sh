#! /bin/bash

# Defininf variables that will be used among the script: Files to use: reference genome, fastq files given by command line, name for the writen files, bed file of desired regions,  adaptors for trimming if provided, and filter if provided

# Usage:
# 	1) Download the software listed in the software section: bwa, gatk, and samtools are by default expected to be in the PATH, picard, trimmomatic and snpEff are java applications that are assume to be in the same folder. Change it to link to the correct path
#	2) snpEFF 
genome="reference_genome/hg19.fa"
fq1=$1
fq2=$2
name=$3
bed=$4
adapters=$5
filter=$6


# SOFTWARE
# Paths to the software used and related: bwa, samtools, picard, gatk and trimommatic with some default options
bwa="bwa mem -t 8"
samtools="samtools"
picard="java -jar picard.jar"
gatk="gatk-4.1.9.0/gatk"
trim="java -jar Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 8 -phred33 -trimlog"
snpEff='java -jar snpEff/snpEff.jar'

# DATABASES

snpDB="GRCh37.75"
clinvar="clinvar.vcf.gz"
dbsnp="dbsnp151.vcf.gz"

#################################################################
#		1.-Quality Control				#
#################################################################

metadata="@RG\tID:$3\tSM:$3\tPL:illumina\tLB:lib1\tPU:unit1"

## 0.- Creates a folder with the name given as $3 which will be used as a prefix for all filenames
## Then starts the quality control, after the folder has been created
echo 'Step 1: Quality control'
if [ ! -d $name ]; then 
	mkdir -p $name;
	if [ $? -ne 0 ]; then
	exit $?
	fi
fi

#1.-Calls Trimmomatic to cut, trim and delete sequences that do not meet the quality criteria
echo 'Trimming sequences'
time java -jar ../software/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 8 -phred33 $fq1 $fq2 $name/$name.trimmed.R1.fq.gz $name/$name.unpaired.R1.fq.gz $name/$name.trimmed.R2.fq.gz $name/$name.unpaired.R2.fq.gz -summary $name/trim_summary.txt ILLUMINACLIP:../software/Trimmomatic-0.39/adapters/TruSeq3-PE.fa/:2:30:10 #TRAILING:25 MINLEN:100 > $name.log

#################################################################
#	                2.-Alignment				#
#################################################################


# 2.- Align the sequences of both PE fastq files to the reference genome. Metadata is created using the name given as $3. Plain text is sorted and then turned to binary bam file
echo 'Step 2: Aligning sequences'
time $bwa -B 40 -O 60 -E 10 -L 50 -R $metadata $genome $name/$name.trimmed.R1.fq.gz $name/$name.trimmed.R2.fq.gz | samtools sort | samtools view -bS -o $name/$name.bam -@ 8 >> $name.log
# 2.5- After alignment, the bam file is indexed (required by next steps, and each time a bam file is created, it will be indexed.
samtools index $name/$name.bam
# 3.- Duplicated reads are marked so the caller can act according to duplications. A new bam with '$name-dedup.bam' is created and used downstream now onwards. This bam is indexed.
echo 'Step 3: Marking duplicated reads'
time $picard MarkDuplicates --INPUT "$name/$name.bam" --OUTPUT "$name/$name-dedup.bam" --M $name/$name.duplicates.txt #--REMOVE_DUPLICATES >> $name.log 2>> $name.log
samtools index $name/$name-dedup.bam
# 4.- Base qualities are checked, and recalibrated if necessary
echo 'Step 4: Recalibrating base qualities'
$gatk BaseRecalibrator -I $name/$name-dedup.bam -R $genome --known-sites known_variants/dbsnp_hg38.vcf.gz -O $name/recal.table
$gatk ApplyBQSR -R $genome -I $name/$name-dedup.bam --bqsr-recal-file $name/recal.table -O $name/$name-recal.bam


#################################################################
#		3.-Variant Calling				#
#################################################################

# 5.- Haplotype caller starts the variant calling process, and produces '$name.vcf.gz' with the raw called variants
echo 'Step 5:Calling Variants'
time $gatk HaplotypeCaller -R $genome -I "$name/$name-recal.bam" -O "$name/$name.vcf.gz" --min-assembly-region-size 5 >> $name.log
# 6.- Variant recalibration allows to recalculate and correct the depth and value of the variants called. This improves the confidence in the called dataset
echo 'Step 6: Recalibrating variants'
## Uses variant data to produce a machine learning model which can help to discover False Positives. The model needs Truth and training datasets to produce the model: In this case, hapmap as the truth values (which are more curated) and dbsnp and 1000G datasets as training datasets.
$gatk VariantRecalibrator -R $genome -V $name/$name.vcf.gz -resource:hapmap,known=false,training=true,truth=true,prior=15.0 known_variants/hapmap3.3.hg38.vcf.gz -resource:1000G,known=false,training=true,truth=false,prior=10.0 known_variants/resources_broad_hg38_v0_1000G_omni2.5.hg38.vcf.gz  -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 known_variants/dbsnp_hg38.vcf.gz -an DP -an QD -an FS -an MQRankSum -an ReadPosRankSum -mode SNP -O $name/output.recal --tranches-file $name/output.tranches --rscript-file $name/output.plots.R

$gatk ApplyVQSR -R $genome -V $name/$name.vcf.gz -O $name/$name-recal-snp.vcf.gz --truth-sensitivity-filter-level 99.0 --tranches-file $name/output.tranches -recal-file $name/output.recal -mode SNP 

$gatk VariantRecalibrator -R $genome -V $name/$name.vcf.gz -resource:1000G,known=false,training=true,truth=true,prior=10.0 known_variants/resources_broad_hg38_v0_Mills_and_1000G_gold_standard.indels.hg38.vcf.gz -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 known_variants/dbsnp_hg38.vcf.gz -an DP -an QD -an FS -an MQRankSum -an ReadPosRankSum -mode INDEL -O $name/output-indel.recal --tranches-file $name/output-indel.tranches --rscript-file $name/output-indel.plots.R 

$gatk ApplyVQSR -R $genome -V $name/$name-recal-snp.vcf.gz -O $name/$name-recal.vcf.gz --truth-sensitivity-filter-level 99.0 --tranches-file $name/output-indel.tranches -recal-file $name/output-indel.recal -mode INDEL 

#################################################################
#		4-Variant Annotation				#
#################################################################


# 7.- Gold standars (such as hapmap and Mills indels) allow to check whether variants called are previously known and thus possess an rs ID. This can be used as a filtering criterion
echo 'Step 7: Annotating variants from gold standars'
$gatk VariantAnnotator -R $genome -V "$name/$name.vcf.gz" --dbsnp known_variants/dbsnp_hg38.vcf.gz --O $name/$name-ID.vcf.gz >> pipeline.log
# 8.- Filtering variants with low depth (or other criteria) or in unwanted regions
$gatk SelectVariants -R $genome -V $name/$name-ID.vcf.gz -O $name/$name-refseq.vcf.gz -L $4 
echo 'Annotating variants from predictions (SnpEff)'
$snpEff -v $snpDB $name/$name-ID.vcf.gz | gzip > $name/$name-refseq-snpeff.ID.vcf.gz

## Future ampliation for the report

#################################################################
#		5-Gathering data for report			#
#################################################################

#################################################################
#		6-Producing the report				#
#################################################################


echo
echo 'Done'
