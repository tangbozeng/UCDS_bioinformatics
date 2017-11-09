cd /usr/local/bin/
sudo wget https://www.cog-genomics.org/static/bin/plink170725/plink_linux_x86_64.zip
sudo unzip -o plink_linux_x86_64.zip
sudo rm -f plink_linux_x86_64.zip
cd plink-1.07-x86_64/
echo export PATH=$PATH:$(pwd) >> ~/.bashrc
source ~/.bashrc # install and biuld PLINK
cd
git clone https://github.com/vcftools/vcftools.git
cd vcftools
./autogen.sh
./configure
make
sudo make install # install and biuld vcftools
sudo apt-get update && sudo apt-get install -y gdebi-core r-base r-base-dev
sudo gdebi -n rstudio-server-1.0.143-amd64.deb # install R
mkdir ~/GWAS && cd ~/GWAS
wget https://de.cyverse.org/dl/d/E0A502CC-F806-4857-9C3A-BAEAA0CCC694/pruned_coatColor_maf_geno.vcf.gz
gunzip pruned_coatColor_maf_geno.vcf.gz
wget https://de.cyverse.org/dl/d/3B5C1853-C092-488C-8C2F-CE6E8526E96B/coatColor.pheno
vcftools --vcf pruned_coatColor_maf_geno.vcf --plink --out coatColor
plink --file coatColor --allow-no-sex --dog --make-bed --noweb --out coatColor.binary
cat pruned_coatColor_maf_geno.vcf | awk 'BEGIN{FS="\t";OFS="\t";}/#/{next;}{{if($3==".")$3=$1":"$2;}print $3,$5;}'  > alt_alleles
plink --bfile coatColor.binary --make-pheno coatColor.pheno "yellow" --assoc --reference-allele alt_alleles --allow-no-sex --adjust --dog --noweb --out coatColor
plink --bfile coatColor.binary --make-pheno coatColor.pheno "yellow" --assoc --reference-allele alt_alleles --allow-no-sex --adjust --dog --noweb --out coatColor
sudo Rscript -e "install.packages('qqman',  contriburl=contrib.url('http://cran.r-project.org/'))"
unad_cutoff_sug=$(tail -n+2 coatColor.assoc.adjusted | awk '$10>=0.05' | head -n1 | awk '{print $3}')
unad_cutoff_conf=$(tail -n+2 coatColor.assoc.adjusted | awk '$10>=0.01' | head -n1 | awk '{print $3}')
Rscript -e 'args=(commandArgs(TRUE));library(qqman);'\
'data=read.table("coatColor.assoc", header=TRUE); data=data[!is.na(data$P),];'\
'bitmap("coatColor_man.bmp", width=20, height=10);'\
'manhattan(data, p = "P", col = c("blue4", "orange3"),'\
'suggestiveline = 12,'\
'genomewideline = 15,'\
'chrlabs = c(1:38, "X"), annotateTop=TRUE, cex = 1.2);'\
'graphics.off();' $unad_cutoff_sug $unad_cutoff_conf
