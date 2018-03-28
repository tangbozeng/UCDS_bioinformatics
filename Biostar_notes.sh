pwd # 查看当前文件夹路径。
mkdir work# 新建一个目录
cd work# 进入work目录
cd ..# 返回上一层目录
rmdir work# 删除work目录
touch abc.txt# 新建一个文件
mv abc.txt xyz.txt# 重命名（移动文件）

#从SGD上获取数据.

#用curl命令把URL下载下来，并存储一个叫 sc.gff 的文件中.
#*每个文件都有一个唯一的URL，也就是网址，用curl可以把这个URL对应的东西下载下来
#*大家可以尝试输入curl –h查看-o的含义:把标准输出更为写入到文件。
curl http://downloads.yeastgenome.org/curation/chromosomal_feature/saccharomyces_cerevisiae.gff -o sc.gff
#*大家可以尝试把-o sc.gff去掉，会发现，这个saccharomyces_cerevisiae.gff文件的内容是边下载边呈现在屏幕上。
#大家可以通过快捷键ctrl+C把这个进程结束掉。
#或者，假如这个网站下载数据似乎比较慢。
#但问一下自己，从一个课程网站下载，速度比官方数据存放网站要快是不是有些奇怪？加油，SGD!
#curl http://www.personal.psu.edu/iua1/courses/files/2014/data/saccharomyces_cerevisiae.gff-o sc.gff
#*上面这条命令是从该课程的网站上下载数据，跟上一条命令下载的是是同一个数据。译者实测速度为：官网13‘，课程网站11’。

wc -l sc.gff#来看看这个文件有多少行。

#按页翻看这个文件内容：用more（或者less）
#SPACE（译者：也就是空格键）和f 是向往下翻页， b 是往上翻页,q 是退出, h 是帮助,/ 进入搜索。
more sc.gff

head sc.gff#我们来看看这个文件的前面几行
tail sc.gff#以及文件的结尾.
grep YAL060W sc.gff#这条命令的含义是，把sc.gff这个文件中，含有YAL060W的所有行挑选出来。
grep YAL060W sc.gff > match.gff#我们可以把这些所得到的匹配结果存放到一个文件中。

#管道命令（多个命令连用）
#有多少行是匹配“gene”这个词的?

grep gene sc.gff | wc -l#*这个命令是先把含有gene一词的行选出来，然后用wc -l查看有多少行
grep gene sc.gff | grep chrVI | wc -l#有多少行是同时匹配“gene”和“chrVI”(6号染色体)这两个词?
grep gene sc.gff | grep chrVI | grep -v Dubious | wc -l#* -v是反转匹配（invert match）的意思，这里就是挑选除了匹配Dubious之外的所有行。

 
#这个文件有点奇怪。它分为两个部分,表格部分是tab分隔的9列数据，另一部分是一条完整的基因组序列
#把这个文件分为两部分。把基因组序列之前的所有行存进文件features.gff.
cat -n sc.gff | head#我们发现，出现含有单词“FASTA”的行就意味着基因组信息从这里开始。
cat -n sc.gff | grep FASTA#找到“FASTA”在文件中的位置。 -n是指，把文件的行号输出来。
head -22994 sc.gff | grep -v '#' > features.gff#把这个行号之前的所有含基因组特征的行存进新的文件中。去除含有“#”的注释行
wc -l features.gff#整了这么多，我们只是想单独把表格形式的这些信息分选出来。来看看这些特征信息有多少行。
cut -f 1,2,3 features.gff | head#* cut 在不指定分隔符的时候，默认是tab分割。
#如果是其他分隔符，可以用-d指定分隔符类型，
#以逗号分隔（比如csv格式）为例：cut -d "," -f 1,2,3 features.gff | head

#去除这个GFF文件的第三列重复的词
#*这里sort是从小到大排序。
#uniq 命令是把同样的词只保留一个。
#*举例来说，比如一组数据有1，1，2，3，3，3.经过uniq就变为1，2，3
cut -f 3 features.gff |sort | uniq | head

#也可以计算某个词有多少个重复（uniq 加-c后显示重复个数）
cut -f 3 features.gff |sort | uniq -c | head
ecture 3 - 安装和使用Entrez Direct

# 安装和使用Entrez Direct软件套件
cd # 到home目录下。
cd ~/src# 进入src目录
curl ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.zip -O# 获取entrez direct 工具包,大写 -O
unzip edirect.zip# 解压这个工具包.
cd edirect# 查看新工具。



mkdir -p ~/edu/lec3# 为这节课创建一个文件夹
cd  ~/edu/lec3
# 运行 einfo

einfo -help



# 抓取描述信息，然后查看它们。

einfo -dbs > einfo-dbs.txt

more einfo-dbs.txt

einfo -db sra > einfo-sra.txt

more einfo-sra.txt



# 运行esearch。

esearch -help

esearch -db nucleotide -query PRJNA257197

esearch -db sra -query PRJNA257197

esearch -db protein -query PRJNA257197



#*译者注：-db是指定数据库类型，而query是跟着你要搜索的关键词。esearch -db nucleotide -query PRJNA257197这条命令的意思就是，在nucleotide这个数据库（database，简称db）里用关键词PRJNA257197搜索。以此类推。

#*不知什么原因，这个出来的结果不是很好看。

#*我来给大家解释一下这个运行结果。

#*以 esearch -db nucleotide -query PRJNA257197 这条命令为例



1：数据库类型为nucleotide，我们esearch的时候就指明了，我们要在nucleotide这个数据库=里搜索

2：搜索关键词数量：1（因为我们只输入了一个关键词，就是PRJNA257197）

3：搜索得到的条目有249个。

#*这么解释一下有没有感觉好点？



#*这一步相当于你到NCBI的首页，做了下图的操作：



#*并点了Search

#*看！果然是249条检索结果。





# 抓取nucleotides数据。

#*译者注：前面只是做了搜索，但是要把数据弄下来，我们需要进一步用别的方式获取并存储下来。这里是用efetch把这249个搜索结果的fasta（也就是碱基序列）给存到了ebola.fasta里面。-format是指定格式，这里指定为fasta

esearch -db nucleotide -query PRJNA257197 | efetch -format fasta > ebola.fasta



# 来看一下这个文件里有多少条序列

#*fasta格式的一个特点就是以>开头，后面跟着序列的相关信息（没有也无妨）。下一行才是序列。fasta有时候也简称为fa。

cat ebola.fasta | grep ">" | wc -l



# 以GenBank格式获取数据

esearch -db nucleotide -query PRJNA257197 | efetch -format gb > ebola.gb





Lecture 4 - 安装和使用SRA toolkit



# 进入你的source目录。

#*原文为cd ~/srrc，应是笔误，这里更正为：

cd ~/src

# 下载 SRA toolkit (确保你的下载链接对应的软件版本是跟你的系统一致的。）

#*建议安装最新版本：



#Mac

curl -O https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.2/sratoolkit.2.8.2-mac64.tar.gz

# Linux.

curl -O https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.2/sratoolkit.2.8.2-ubuntu64.tar.gz

#*以下命令，译者皆将旧版本改为新版本名称，如想继续安装旧版本，可以按着原英文版本安装。

#*原文版本是：

# Mac OSX.

curl -O http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.3.5-2/sratoolkit.2.3.5-2-mac64.tar.gz

# Linux.

curl -O http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.3.5-2/sratoolkit.2.3.5-2-ubuntu64.tar.gz



# 解压。（译者注：这是mac上的）

tar xzvf sratoolkit.2.8.2-mac64.tar.gz

#*方便起见，译者也给出Linux的：

tar xzvf sratoolkit.2.8.2-ubuntu64.tar.gz



# 转到这个目录下，并查看里面的文件。

cd sratoolkit.2.8.2-ubuntu64/

#*mac上

#*cd sratoolkit.2.8.2-mac64/



# 程序都在这个bin目录下

cd bin

# 来看看有什么。

ls



# 我们来把这些路径永久加到我们的PATH下。

#*前面提到export PATH=$PATH:~/src/edirect

#*这个命令只能是目前可以用，一旦退出系统，再重新进入，系统就不识别了。这里作者开始介绍如何使之变成每次进入这个终端都可以使用。

# 有一个特殊的文件在shell开启时会被系统自动读入。它为你开启的任一终端都提供好这些设置。这个文件在Mac上叫~/.profile，在linux上叫 ~/.bashrc 。 “ >> ”符号是指，把内容追加到一个文件后面，而非直接覆盖这个文件的原内容。你也可以通过text编辑器来编辑这个文件。

# Mac上:

echo export PATH=$PATH:~/src/edirect:~/src/sratoolkit.2.8.2-mac64/bin >> ~/.profile

# Linux上:

echo export PATH=$PATH:~/src/edirect:~/src/sratoolkit.2.8.2-ubuntu64/bin >> ~/.bashrc



# 你需要重新开启一个新的终端来使得上面的设置生效，或者你也可以：

source ~/.profile

#*译者温馨提醒：如果是Linux的话：source ~/.bashrc



# 转到 lecture 文件夹下。 -p 是用来做什么的？请看手册。

#* 可以用man mkdir查看mkdir的使用手册。

mkdir -p ~/edu/lec4

cd ~/edu/lec4



# 命令prefetch在哪里？

which prefetch



# 命令prefetch 可以从远程站点下载文件。

#来看一下帮助文档。

prefetch -h



# 来获取文件。

prefetch SRR1553610



# 这些文件去哪里了？存在了你home目录下的一个默认文件夹里。

ls ~/ncbi



# 里面添加了什么？可以用工具find来查看。

find ~/ncbi



# 我们用程序fastq-dump来把文件拆包

#*从NCBI下下来的数据，双端测序数据是放在一个文件里的，所以需要把它们重新拆解为两个文件。

fastq-dump -h

# 拆包文件

fastq-dump --split-files SRR1553610

# FASTQ格式的原始数据文件已经在当前文件夹了。

#*FASTQ格式在之前《小白生信学习记3》中有较为详细的介绍。但NCBI上下的fastq可能会跟测序得到的略为不同。



ls



# shell下的模式匹配。* (星号)表示可以匹配任何东西。

wc -l *.fastq



# 查看文件。

head SRR1553610_1.fastq

cat *.fastq | grep @SRR | wc -l



# 如何下载多个文件？创建一个含有SRR runs的文件。

echo SRR1553608 > sra.ids

echo SRR1553605 >> sra.ids



# 用这个文件去prefetch对应的runs.

prefetch --option-file sra.ids



# 拆包下载好的所有文件。请注意下边的做法不是特别妥当，因为（文件夹里）除了我们用sra.ids下载的，可能还有别的prefetch下来的文件。

fastq-dump --split-files ~/ncbi/public/sra/SRR15536*



# 正确的解法是，我们只拆包sra.ids里指定的文件。哎，但是fastq-dump不能直接实现。无语！

# 正确的解决这个问题，需要使用命令行作一些字符串处理

# 这会用到sed (字符流编辑器) 工具来提取文件并替换其中的模式“SRR”

cat sra.ids | sed 's/SRR/fastq-dump --split-files SRR/'



# 现在，把输出传到bash

cat sra.ids | sed 's/SRR/fastq-dump --split-files SRR/' | bash



# 我们还要做的更好。 为什么要去一一复制这些SRR ID ？我们其实可以完全通过命令行来获取它们。

# 然而efetch程序有一个bug。它获取到数据，但在结尾还会有一个error，为啥？很可能就是有个bug！无语! x 2

esearch -db sra -query PRJNA257197  | efetch -format runinfo



# 这个命令是把所有的结果放到一个文件里。

esearch -db sra -query PRJNA257197  | efetch -format runinfo > runinfo.txt



# 并且，由于这是一个逗号分隔符的文件，我们需要把分隔符（用以区别不同列的符号）指明给cut程序。

cat runinfo.txt | cut -f 1 -d ","



# 似乎所有的文件都在这了。这次搜索获得了195个文件（译者注：其实今天这个搜索结果已经到了891个了，下边我会直接使用891这个数据而不再提示）。

# 问: 我们相信这个结果吗？我们可以通过网站BioProject来获取文件，但你需要在正确的位置来实现这个功能。（文末译者会给出网站上如何获取这个list的方法。）

cat runinfo.txt | cut -f 1 -d ',' | grep SRR | wc -l



# 我们相信这个结果。但是可能你会有种不安，感觉自己可能犯错了。欢迎加入组织！

#*在我给出的网页版下载listd的方法的截图里，你也可以看到，最终结果确实是891个，跟命令行获取的是一样的。

cat runinfo.txt | cut -f 1 -d ',' | grep SRR > sra.ids



# 警告! 这会下载很多文件 (精确来说是891个).

# 目测这网速估计需要好几个小时。（译者注：这是作者基于195个结果作的判断）

prefetch --option-file sra.ids

#*如果你也想尝试一下下载，但又不想下载这么多。你可以这么做：

#*head sra.ids > sra_test.ids

#*prefetch --option-file sra_test.ids



# 检查一下下载结果的总大小

du -hs ~/ncbi



# 来把它们都转换了

cat sra_test.ids | sed 's/SRR/fastq-dump --split-files SRR/' | bash



# 这所有的文件一共有多少行？

wc -l *.fastq

# 通过这种方式，我们得到了PRJNA257197这个项目下所有的测序数据。

#*获取一个project里的所有SRR ID

#*首先进入https://www.ncbi.nlm.nih.gov/sra/

#*输入你要找的这个编号：PRJNA257197



#*点击search

#*会看到很多检索结果。



#*点击右上角的send to



#*选定File，并把Format改为RunInfo

#*点击Create File就生成了一个SraRunInfo.csv文件了。

#*有没有发现，你其实只是把这种网页版的操作变成了几乎一一对应的命令行操作而已。
