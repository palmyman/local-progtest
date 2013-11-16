#!/bin/bash
clear;
echo "         _                 _                         _            _   
        | |               | |                       | |          | |  
        | | ___   ___ __ _| |  _ __  _ __ ___   __ _| |_ ___  ___| |_ 
        | |/ _ \ / __/ _\` | | | '_ \| '__/ _ \ / _\` | __/ _ \/ __| __|
        | | (_) | (_| (_| | | | |_) | | | (_) | (_| | ||  __/\__ \ |_ 
        |_|\___/ \___\__,_|_| | .__/|_|  \___/ \__, |\__\___||___/\__|
                              | |               __/ |                 
        by Lubomir Cuhel      |_|              |___/  www.palmyman.com   
                              ";
echo "                 FORK ME @ www.github.com/palmyman/local-progtest";
echo "###############################################################################";
if [ ! -r appFilePath.txt ]; then
	echo "Finding app file...";
	find -type f -executable -not -path "*/.git/*" -not -name "*.sh" > appFilePath.txt;
fi
if [ -r appFilePath.txt ]; then
	found=`cat appFilePath.txt | wc -l`;
else 
	found=0;
fi
if [ "$found" = "1" ]; then		
	appFile=`cat appFilePath.txt`;
	if [ ! -f $appFile ]; then
		echo "path: $appFile";
		echo "Invalid path to app file loaded. Edit or delete appFilePath.txt config file.";
		echo "README can be seen @ www.github.com/palmyman/local-progtest";
		exit;
	fi	
	echo "path: $appFile";
	echo "date: `date`";
elif [ "$found" = "0" ]; then
	echo "No app file candidates found in this project directory. Please build the project.";
	echo "README can be seen @ www.github.com/palmyman/local-progtest";
	rm -f appFilePath.txt;
	exit;
else
	echo "Multiple app file candidates found:";
	cat appFilePath.txt;
	echo "Please edit appFilePath.txt config file to have only one line.";
	echo "README can be seen @ www.github.com/palmyman/local-progtest";
	exit;
fi

if [ ! -r  ./sample/0000_in.txt ]; then
	echo "Sample 0000_in.txt not found. Samples have to be saved in ./sample directory.";
	echo "README can be seen @ www.github.com/palmyman/local-progtest";
	exit;
fi

if [ "$1" = "" ]; then
	todo=`seq 0 9999`
else
	todo="$@"
fi
errors=0;
count=0;
for i in $todo
do
	li=`printf %04d $i`
	if [ -r sample/"$li"_in.txt ]; then
		./"$appFile" < sample/"$li"_in.txt > sample/myoutput.txt;
		diff sample/myoutput.txt sample/"$li"_out.txt > /dev/null;
		if [ "$?" = "1" ]; then		
			echo "------------------------------------ $li -------------------------------------";
			cat "sample/$li"_in.txt;
			echo "-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -";		
			diff sample/myoutput.txt sample/"$li"_out.txt;
			let errors+=1;
		fi
		let count=$count+1
	else
		rm -f sample/myoutput.txt;
		break;
	fi
done
echo "-------------------------------------------------------------------------------";
let correct=$count-$errors;
if [ "$count" = "0" ]; then
	success=0;
else
	success=`echo "scale=2; $correct * 100 / $count" | bc -l`;
fi
printf "Total\tCorrect\tErrors\tSuccess\n";
printf "$count\t$correct\t$errors\t$success%%\n";
echo "###############################################################################";
if [ "$success" = "100.00" ]; then
	echo "Well done :) If you like it and/or have any ideas check this repo @ GitHub.";
fi
