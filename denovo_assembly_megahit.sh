
git clone https://github.com/voutcn/megahit.git
cd megahit
make -j 6
mkdir ~/work
cd ~/work
curl -O -L https://s3.amazonaws.com/public.ged.msu.edu/ecoli_ref-5m.fastq.gz
~/megahit/megahit --12 ecoli_ref-5m.fastq.gz -o ecoli # ecoli is the folder for saving files
cp ecoli/final.contigs.fa ecoli-assembly.fa #copy and save the denovo file first
head ecoli-assembly.fa
cp ecoli/final.contigs.fa ecoli-assembly.fa
head ecoli-assembly.fa
cd ~/ # start to measure your assembly
git clone https://github.com/ablab/quast.git -b release_4.5
export PYTHONPATH=$(pwd)/quast/libs/
cd ~/work
~/quast/quast.py ecoli-assembly.fa -o ecoli_report
cat ecoli_report/report.txt
