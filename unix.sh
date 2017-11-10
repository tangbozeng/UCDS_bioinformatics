#Unix programming
cmd+K #clear ctril+L in linux
echo ‘hello world’ #print
control+a # move to start of line
control+e # move to end of line

command SPACE options SPACE argument #基本语法 命令 选择条件 输出

echo ‘hello’; echo ‘wold’
hello
world # 分开的

echo $0 # the shell we are working now

Manual pages man@@@@
control + C # interrupt signal
1: Q is quit, exit
  F前进， b 就是回去
man echo # list of functions

pwd   # present working directory
ls       #
ls -l   # (L) information of files
ls -la # extra stuff, including hiding things
ls -lah # including size

cd name of directory # change working directory
cd .. #回到上一层
cd -# go back to recent previously place
cd ‘Application Support’ # go fold with space name
cd ad cd ~ # same

touch somefile.txt # creat and modif ysome file.txt
cat file1 file2 # read files
less # is best for reading files
head ok.txt # beginning of the file
tail # end of the file

mkdir tester # create directory
mkdir tester/tester # create tester in tester as folder
mkdir -p test1/test2/test3/ # create with more than 2folders

mv ok.txt Desktop/ok.txt # 把ok.txt移动到桌面

grep # for search 
grep apple fruit.txt #search apple  in fruit.txt, 识别大小写
grep -i Apple fruit.txt # -i 不管大小写
grep -w apple fruit.txt # 只找整个的apple，不带别的字母的，pineapple就没了
grep -n apple fruit.txt # 给出所在line数
grep -c apple fruit.txt #有多少次的
grep apple /Users/tangbozeng/unix_files/ # 指定了文件夹
grep  -R apple /Users/tangbozeng/unix_files/ # -R 要所指文件夹里所有的东西
grep  -Rn apple /Users/tangbozeng/unix_files/ # 外带line数
grep  -Rh apple /Users/tangbozeng/unix_files #不要文件夹名字
grep  -Rl apple /Users/tangbozeng/unix_files #主要名字
grep  -Rl apple /Users/tangbozeng/unix_files #没有apple的文件 和-v很像
grep ’something’ filename # search something in filename
grep -v ‘>’ intron_IME_data.fasta #  show which is not match with what you look for

grep -i ACGTC * | head # grep search, -i ignore cases, ACGTC, * all files, get heads of each

grep "^ATG.*ACACAC.*TGA$" chr1.fasta # ^ is to tell only match ATG starts, $ is end of the line, 
ls *.txt # 找到特定的文件夹，这个很重要其实

grep apple *fruit.txt # 只在有fruit的字眼的文件里找apple
ps aux | terminal # 只要有terminal的
history | grep unix_files # 在历史命令中找有特定字符的
grep —color lorem lorem.txt # 上色被找到的字符

regular expressions

‘’是好习惯 ‘apple’

grep ‘a..le’ fruit.txt # 
grep ‘.a.a.a’ fruit.txt # 找pattern
grep ‘ea’ fruit.txt #
grep ‘ea[cp]’ fruit.txt # ea之后只要c或者p

. # wild card = anything
[] # g[123]y, 可以有，1，2，3
[^] # g[^ea]y, 不要e，不要a
-# [A-Za-z0-9] 在这个范围之间
* # 0次或多次 file_*name
+ # 一次或多次 gro+ve
? # 0次或1次 colou?r
| # alternative， (jpg|gif|png), 是jpg，gif， 还是png
^ # ^hello 找这个行里以hello给开始的，这个和[^hello]有本质区别
$ # world$ 找到行里以world为结束的行
\
\d #所有的数字 20\d\d-06-09
\D #
\w word or not
\W
\s whitespace or not
\S
grep ‘^p’ fruit.txt #以p为头的
grep ‘berry¥’ fruit.txt #以berry为尾
echo ‘AaBbCcDd’ | grep —color ‘[[:upper:]]’  
grep -E ‘ap+le’ fruit.txt # -E 很好用
grep -E ‘apple|pear’ fruit.txt # 确实好用

tr
echo ‘a,b,c’ | tr ‘,’ ‘_’ # 把.变到 _ 
echo ‘14252546524’ 翻译所有啊
echo ‘abc1233d4eee567f’ | tr ‘bedf5-9’ ‘x’ #把bedf5-9都换成x
echo ‘abc1233d4eee567f’ | tr ‘bedf5-9’ ‘xz’ # 只能把b变成x，其他的都是z
tr’A-Z ‘a-z’ < people.txt # 翻译大写到小写，从people文件来的
tr ‘,’ ‘\t’ < usa.csv  > usa.tsv  # \t for tap,  从这个usa来的，保存回usa

tr -d  echo ‘abc123’ |tr -d [:dight:] # ‘abc’
tr -s 
tr -c
tr -dc
tr -sc

sed ’s/a/b/’

s:substition
a:search
b:replacement

echo ‘upstream and upload’ | sed ’s/up/down/’ # up换成down downstream, 只能换第一个 


cut (KEEP)
cut -c 2-10 file # -c for字母
echo ‘a lot of words’  | wc # 可以先数数，再决定
ls | cut -c 24- # 从24以后
cut -f 2,6 #只要2，6的column
-d ‘,’ # 用，做delimiter，也就说分行的工具

diff file1 file2 # 比较俩文件
-i 不在乎大小写
-b 不在乎空白
-w
-B
-r
-s


diff file1 file2 | diffstat
-c
-u
-y
-q

xargs

compiling Unix software packages
steps:
1. download and locate
2. unpack
3. compile the code
4. install the executable stuff
5. set paths

make # get rules from file Makefile
configure # to correct the values for various system variables

the simplest way to is:
1. cd to the directory
2. type ./configure
3. make
4. (make check) # to run any self-tests
5. make install
6. (make clean) # to remove the program from the source


- -prefix # specify installation directory
 - -exec-prefix #

mkdir download # create dic
cd download # locate download
ls -l # get list
less README
less INSTALL
mkdir ~/thediryouwanttoinstall
./configure - - prefix=$HOME/thedir…
echo $HOME  # check your own home path

make # build
make check # check if it is ok
make install # will install the package where you defined

echo to check add $
* USER (your login name)
* HOME (the path name of your home directory)
* HOST (the name of the computer you are using)
* ARCH (the architecture of the computers processor)
* DISPLAY (the name of the computer screen to display X windows)
* PRINTER (the default printer to send print jobs)
* PATH (the directories the shell should search to find a command)
