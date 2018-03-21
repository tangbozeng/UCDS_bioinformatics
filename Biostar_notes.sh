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

#*这个命令是先把含有gene一词的行选出来，然后用wc -l查看有多少行。大家可以试试不加-l是什么结果。

grep gene sc.gff | wc -l

 

#有多少行是同时匹配“gene”和“chrVI”(6号染色体)这两个词?

grep gene sc.gff | grep chrVI | wc -l

 

#在上述符合条件的行里，不匹配“Dubious”的有多少行? 

#* -v是反转匹配（invert match）的意思，这里就是挑选除了匹配Dubious之外的所有行。

grep gene sc.gff | grep chrVI | grep -v Dubious | wc -l

 

#这个文件有点奇怪。它分为两个部分,表格部分是tab分隔的9列数据，另一部分是一条完整的基因组序列

 

#把这个文件分为两部分。把基因组序列之前的所有行存进文件features.gff.

#我们发现，出现含有单词“FASTA”的行就意味着基因组信息从这里开始。

cat -n sc.gff | head

 

#找到“FASTA”在文件中的位置。 -n是指，把文件的行号输出来。

cat -n sc.gff | grep FASTA

 

#把这个行号之前的所有含基因组特征信息的行存进新的文件中。同时去除含有“#”的注释行

head -22994 sc.gff | grep -v '#' > features.gff

 

#整了这么多，我们只是想单独把表格形式的这些信息分选出来。来看看这些特征信息有多少行。

wc -l features.gff

 

#把前三列截取出来。

#* cut 在不指定分隔符的时候，默认是tab分割。如果是其他分隔符，可以用-d指定分隔符类型，以逗号分隔（比如csv格式）为例：cut -d "," -f 1,2,3 features.gff | head



cut -f 1,2,3 features.gff | head

 

#去除这个GFF文件的第三列重复的词

#*这里sort是从小到大排序。

#uniq 命令是把同样的词只保留一个。

#*举例来说，比如一组数据有1，1，2，3，3，3.经过uniq就变为1，2，3

cut -f 3 features.gff |sort | uniq | head

 



#也可以计算某个词有多少个重复（uniq 加-c后显示重复个数）

cut -f 3 features.gff |sort | uniq -c | head
