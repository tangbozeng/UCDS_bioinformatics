
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
