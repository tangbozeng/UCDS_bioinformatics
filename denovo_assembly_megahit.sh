
git clone https://github.com/voutcn/megahit.git
cd megahit
make -j 6
mkdir ~/work
cd ~/work
curl -O -L https://s3.amazonaws.com/public.ged.msu.edu/ecoli_ref-5m.fastq.gz
~/megahit/megahit --12 ecoli_ref-5m.fastq.gz -o ecoli
cp ecoli/final.contigs.fa ecoli-assembly.fa #copy and save the denovo file first
head ecoli-assembly.fa
