sudo apt-get -y update && \
sudo apt-get -y install trimmomatic fastqc python-pip \
zlib1g-dev ncurses-dev python-dev
mkdir ~/data
cd ~/data
curl -O http://dib-training.ucdavis.edu.s3.amazonaws.com/2017-ucdavis-igg201b/SRR2584857.fq.gz
cd
curl -L https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.15.tar.bz2/download > bwa-0.7.15.tar.bz2
tar xjvf bwa-0.7.15.tar.bz2
cd bwa-0.7.15
make
sudo cp bwa /usr/local/bin
echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
source ~/.bashrc
mkdir ~/work
cd ~/work
wget https://github.com/ctb/2017-ucdavis-igg201b/raw/master/lab1/ecoli-rel606.fa.gz
gunzip ecoli-rel606.fa.gz
bwa index ecoli-rel606.fa #Prepare it for mapping
bwa mem -t 6 ecoli-rel606.fa ~/data/SRR2584857.fq.gz > SRR2584857.sam # map
head SRR2584857.sam
sudo apt-get -y install samtools # install samtools
samtools view -hSbo SRR2584857.bam SRR2584857.sam #convert the BAM file into a SAM file
samtools sort SRR2584857.bam SRR2584857.sorted #Sort the BAM file by position in genome
samtools index SRR2584857.sorted.bam #Index the BAM file so that we can randomly access it quickly
samtools tview SRR2584857.sorted.bam ecoli-rel606.fa
samtools mpileup -uD -f ecoli-rel606.fa SRR2584857.sorted.bam | \
bcftools view -bvcg - > variants.raw.bcf # find places where the reads are systematically different from the genome
bcftools view variants.raw.bcf > variants.vcf #convert it into the ‘variant call format’ that is human readable
grep -v ^## variants.vcf # Look at the non-commented lines along with the header
grep -v ^## variants.vcf | less -S
