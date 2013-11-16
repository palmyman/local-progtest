local progtest
==============

         _                 _                         _            _   
        | |               | |                       | |          | |  
        | | ___   ___ __ _| |  _ __  _ __ ___   __ _| |_ ___  ___| |_ 
        | |/ _ \ / __/ _` | | | '_ \| '__/ _ \ / _` | __/ _ \/ __| __|
        | | (_) | (_| (_| | | | |_) | | | (_) | (_| | ||  __/\__ \ |_ 
        |_|\___/ \___\__,_|_| | .__/|_|  \___/ \__, |\__\___||___/\__|
                              | |               __/ |                 
        by Lubomir Cuhel      |_|              |___/  www.palmyman.com


Local Progtest is sample tester for CTU server progtest.fit.cvut.cz. Compares output of your program to reference and prints diff.

Basic Manual
------------
1. Save local-progtest.sh file in root of your project.
2. Download samples to you project from progtest and extract them into sample/ directory
3. Build your project to somewhere in your project directory or its subdirs
4. Run the test:

```
./local-progtest.sh
```
Restrictions
------------
+ Sample files names have to be in "Vagner" format:

```
ls sample/
0000_in.txt   0001_in.txt   0002_in.txt   0003_in.txt   0004_in.txt   0005_in.txt
0000_out.txt  0001_out.txt  0002_out.txt  0003_out.txt  0004_out.txt  0005_out.txt
```
+ There can not be multiple executable files in your project directory or its subdirs. If it is so, you will be asked to edit appFilePath.txt file manually. (script is ignoring ./.git/ directory)
+ If running without arguments with one or more samples missing, samples with higher numbers will be ignored.
+ Range of sample file name is 0000_in.txt - 9999_in.txt

Features
--------
+ You can specify what sample you want to test by adding arguments:

+ `./local-progtest.sh 3` will only run sample 3 (files 00003_in/out.txt)
+ `./local-progtest.sh 5 99 8` will only run samples 5, 99 and 8 in given order

+ Note that using number of nonexistent sample will stop the testing (all next arguments will be ignored)
