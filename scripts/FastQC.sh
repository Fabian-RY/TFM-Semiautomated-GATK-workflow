echo 'Analizing multiple Fastq'
files=$(ls $1)
echo $files
for fastq in $files; do
  echo '=========================='
  ../Software/FastQC/fastqc $1/$fastq
done
mv $1/*.zip ./
mv $1/*.html .
