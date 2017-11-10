cd ~/
wget http://www.vicbioinformatics.com/prokka-1.12.tar.gz
tar -xvzf prokka-1.12.tar.gz
sudo apt-get -y install bioperl libdatetime-perl libxml-simple-perl \
    libdigest-md5-perl python ncbi-blast+ fastqc #  need some dependencies such as bioperl
sudo bash
export PERL_MM_USE_DEFAULT=1
export PERL_EXTUTILS_AUTOINSTALL="--defaultdeps"
perl -MCPAN -e 'install "XML::Simple"'
exit #  install some Perl libraries
export PATH=$PATH:$HOME/prokka-1.12/bin
echo 'export PATH=$PATH:$HOME/prokka-1.12/bin' >> ~/.bashrc
prokka --setupdb #add Prokka to your $PATH and set up the index for the sequence database
cd ~/
mkdir annotation
cd annotation
ln -fs ~/work/ecoli-assembly.fa #Link the metagenome assembly file into this directory
prokka ecoli-assembly.fa --outdir prokka_annotation --prefix myecoli # run prokka!
grep -v ^## prokka_annotation/myecoli.gff | head
head prokka_annotation/myecoli.faa
curl -L -o ncbi-ecoli.faa.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_protein.faa.gz
gunzip ncbi-ecoli.faa.gz
makeblastdb -in ncbi-ecoli.faa -dbtype prot
blastp -query prokka_annotation/myecoli.faa -db ncbi-ecoli.faa | less
