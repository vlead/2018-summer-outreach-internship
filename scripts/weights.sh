#!/bin/bash
cat ids.csv | cut -d "," -f 2 | while read projectid
do
sed -i '1s/$/,Tag/' $projectid.csv
csvquote $projectid.csv | sed '/[fF]ull [sS]creen/s/$/Inalid/' | sed '/[gG]rammar/s/$/Inalid/' | sed '/[sS]pelling/s/$/Inalid/' | sed '/[gG]rammatical [eE]rror/s/$/Inalid/' > $projectid-a.csv 

rm $projectid.csv
sed -i -e 's/$/,Valid/' $projectid-a.csv
csvquote $projectid-a.csv | cut -d "," -f 1,2,3,4 | tee $projectid-a.csv

#sed -i '1s/$/,score/' $projectid-a.csv
num_of_s3=$(csvquote $projectid-a.csv | sed '/feedback/s/$/,S3/' | grep S3 | wc -l)
a=$(csvquote $projectid-a.csv | cut -d "," -f 3,4 | sed '/[bB]ug/s/$/,S1a/' | sed '/[fF]unctionality",Valid/s/$/,S1b/' | grep S1a,S1b | wc -l)
b=$(csvquote $projectid-a.csv | cut -d "," -f 3,4 | sed '/[fF]unctionality/s/$/,S1a/' | sed '/[bB]ug",Valid/s/$/,S1b/' | grep S1a,S1b | wc -l)
c=$(csvquote $projectid-a.csv | cut -d "," -f 3,4 | sed '/[eE]nhancement/s/$/,S1a/' | sed '/[fF]unctionality",Valid/s/$/,S1b/'| grep S1a,S1b | wc -l)
d=$(csvquote $projectid-a.csv | cut -d "," -f 3,4 | sed '/[fF]unctionality/s/$/,S1a/' | sed '/[eE]nhancement",Valid/s/$/,S1b/'| grep S1a,S1b | wc -l)
num_of_s1=$((a + b + c + d))
e=$(csvquote $projectid-a.csv | cut -d "," -f 3,4 | sed '/[bB]ug/s/$/,S2a/' | sed '/[cC]ontent",Valid/s/$/,S2b/' | grep S2a,S2b | wc -l)
f=$(csvquote $projectid-a.csv | cut -d "," -f 3,4 | sed '/[cC]ontent/s/$/,S2a/' | sed '/[bB]ug",Valid/s/$/,S2b/' | grep S2a,S2b | wc -l)
g=$(csvquote $projectid-a.csv | cut -d "," -f 3,4 | sed '/[eE]nhancement/s/$/,S2a/' | sed '/[cC]ontent",Valid/s/$/,S2b/' | grep S2a,S2b | wc -l)
h=$(csvquote $projectid-a.csv | cut -d "," -f 3,4 | sed '/[cC]ontent/s/$/,S2a/' | sed '/[eE]nhancement",Valid/s/$/,S2b/' | grep S2a,S2b | wc -l)
num_of_s2=$((e + f + g +h))

total_score=$((num_of_s1 * 5 + num_of_s2 * 3 + num_of_s3 * 1))

echo "$projectid - $total_score" >> scores.txt 
done
