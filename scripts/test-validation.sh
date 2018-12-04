#!/bin/bash
sed -i '1s/$/,Tag/' 1.csv
sed -i '/full screen/s/$/,Invalid/' 1.csv
sed -i '/grammar/s/$/,Invalid/' 1.csv
sed -i '/spelling/s/$/,Invalid/' 1.csv
sed -i '/grammatical error/s/$/,Invalid/' 1.csv
sed -i -e 's/$/,Valid/' 1.csv
cut -d "," -f 1,2,3,4 1.csv | tee 1.csv 
mkdir tests-lab-bucket
cat tests-lab | while read LINE
do
	if cat 1.csv | grep "$LINE" 
	then
		mkdir ./tests-lab-bucket/"$LINE"
		cat 1.csv | grep "$LINE" > ./tests-lab-bucket/"$LINE"/"$LINE.txt" 
	fi
done

ls tests-lab-bucket | while read line
do
	cat ./tests-lab-bucket/"$line"/"$line".txt | cut -d "_" -f 2 >> tests-exp.txt
done  	

sort -u tests-exp.txt -o tests-exp.txt

ls tests-lab-bucket | while read blah
do
	cat tests-exp.txt | while read EXP
	do
		if cat ./tests-lab-bucket/"$blah"/"$blah".txt | grep "$EXP"
		then
			mkdir ./tests-lab-bucket/"$blah"/"$EXP"
			cat ./tests-lab-bucket/"$blah"/"$blah".txt | grep "$EXP" > ./tests-lab-bucket/"$blah"/"$EXP"/"$EXP".txt
		fi	
	done
done

ls tests-lab-bucket | while read line
do
	cat ./tests-lab-bucket/"$line"/"$line".txt | cut -d "_" -f 3 | cut -d "," -f 1 >> tests-sub.txt
done

sort -u tests-sub.txt -o tests-sub.txt

ls tests-lab-bucket | while read blah1
do
	ls -F tests-lab-bucket/"$blah1" | grep / | cut -d "/" -f 1 | while read blah2
	do
		cat tests-sub.txt | while read SUB
		do
			if cat ./tests-lab-bucket/"$blah1"/"$blah2"/"$blah2".txt | grep "$SUB"
			then
				mkdir ./tests-lab-bucket/"$blah1"/"$blah2"/"$SUB"
				cat ./tests-lab-bucket/"$blah1"/"$blah2"/"$blah2".txt | grep "$SUB" > ./tests-lab-bucket/"$blah1"/"$blah2"/"$SUB"/"$SUB".txt
			fi
		done
	done
done
