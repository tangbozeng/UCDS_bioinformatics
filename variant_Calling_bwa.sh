cd /root
wget -O bwa-0.7.10.tar.bz2 http://sourceforge.net/projects/bio-bwa/files/bwa-0.7.10.tar.bz2/download
tar xvfj bwa-0.7.10.tar.bz2
cd bwa-0.7.10
make
cp bwa /usr/local/bin

#Also install samtools

Download data
Download the reference genome and the resequencing reads:
cd /mnt
curl -O http://athyra.idyll.org/~t/REL606.fa.gz
gunzip REL606.fa.gz
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR098/SRR098038/SRR098038.fastq.gz

#Do the mapping
#Start by indexing the reference genome:
cd /mnt
bwa index REL606.fa

#mapping of the raw reads to the reference genome:
bwa aln REL606.fa SRR098038.fastq.gz  > SRR098038.sai

#Make a SAM file (this would be done with ‘sampe’ if these were paired-end reads):
bwa samse REL606.fa SRR098038.sai SRR098038.fastq.gz > SRR098038.sam

#Next, index the reference genome with samtools:
samtools faidx REL606.fa
#Convert the SAM into a BAM file:

samtools import REL606.fa.fai SRR098038.sam SRR098038.bam
#Sort the BAM file:
samtools sort SRR098038.bam -o SRR098038.sorted
#And index the sorted BAM file:
samtools index SRR098038.sorted
#Visualizing alignments
#samtools tview’ is a text interface that you use from the command line; run it like so:
samtools tview SRR098038.sorted REL606.fa

#Counting alignments
This command:

samtools view -c -f 4 SRR098038.bam
will count how many reads DID NOT align to the reference (214518).

This command:

samtools view -c -F 4 SRR098038.bam
will count how many reads DID align to the reference (6832113).

And this command:

gunzip -c SRR098038.fastq.gz | wc
will tell you how many lines there are in the FASTQ file (28186524). Reminder: there are four lines for each sequence.

Calling SNPs
You can use samtools to call SNPs like so:

samtools mpileup -uD -f REL606.fa SRR098038.sorted.bam | bcftools view -bvcg - > SRR098038.raw.bcf
(See the ‘mpileup’ docs here.)

Now convert the BCF into VCF:

bcftools view SRR098038.raw.bcf > SRR098038.vcf
You can check out the VCF file by using ‘tail’ to look at the bottom:

tail *.vcf

