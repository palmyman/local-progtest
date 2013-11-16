#!/bin/bash
echo "###############################################################################";
echo "         _                 _                         _            _   
        | |               | |                       | |          | |  
        | | ___   ___ __ _| |  _ __  _ __ ___   __ _| |_ ___  ___| |_ 
        | |/ _ \ / __/ _\` | | | '_ \| '__/ _ \ / _\` | __/ _ \/ __| __|
        | | (_) | (_| (_| | | | |_) | | | (_) | (_| | ||  __/\__ \ |_ 
        |_|\___/ \___\__,_|_| | .__/|_|  \___/ \__, |\__\___||___/\__|
                              | |               __/ |                 
        by Lubomir Cuhel      |_|              |___/  www.palmyman.com   
                              ";
echo "###############################################################################";
zero=000;
if [ ! -r appFilePath.txt ]; then
	echo "Finding app file...";
	find -type f -executable -not -path "*/.git/*" -not -name "*.sh" > appFilePath.txt;
fi
if [ -r appFilePath.txt ]; then
	found=`cat appFilePath.txt | wc -l`;
else 
	found = 0;
fi
if [ "$found" = "1" ]; then		
	appFile=`cat appFilePath.txt`;
	if [ ! -f $appFile ]; then
			echo "Ivalid path to app file loaded. Edit or delete appFilePath.txt config file.";
			echo "path: $appFile";
			exit;
	fi	
	echo "path: $appFile";
	echo "date: `date`";
elif [ "$found" = "0" ]; then
	echo "No app file candidates found in this project directory. Please build the project.";
	rm -f appFilePath.txt;
	exit;
else
	echo "Multiple app file candidates found:";
	cat appFilePath.txt;
	echo "Please edit appFilePath.txt config file to have only one line.";
	exit;
fi

if [ ! -r  ./sample/0000_in.txt ]; then
	echo "Sample 0000_in.txt not found. Samples have to be saved in ./sample directory.";
	exit;
fi

if [ "$1" = "" ]; then
	start=0;
	end=9999;
else
	start=$1;
	end=$1;
fi
errors=0;
for ((i=$start; i<=$end; i++))
do
	if [ "$i" = "10" ]; then
		zero=00;
	fi
	if [ "$i" = "100" ]; then
		zero=0;
	fi
	if [ "$i" = "1000" ]; then
		zero="";
	fi
	
	if [ -r sample/"$zero$i"_in.txt ]; then
		./"$appFile" < sample/"$zero$i"_in.txt > sample/myoutput.txt;
		diff sample/myoutput.txt sample/"$zero$i"_out.txt > /dev/null;
		if [ "$?" = "1" ]; then		
			echo "------------------------------------ $zero$i -------------------------------------";
			cat "sample/$zero$i"_in.txt;
			echo "-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -";		
			diff sample/myoutput.txt sample/"$zero$i"_out.txt;
			let errors+=1;
		fi
	else
		rm -f sample/myoutput.txt;
		break;
	fi
done
echo "-------------------------------------------------------------------------------";
let count=$i-$start;
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
	echo "Well done :) If you like it or/and have any ideas star this project at ";
fi