#!/bin/bash
set -x
#echo "script vers: $(git rev-parse HEAD)"
#echo "start time: $(date)"

#git config --global user.name "suzzy777"
#git config --global user.email "suzzanarafi@gmail.com"

$1
$2
$3

#smalldata=$1
#smalldatamd5=$2
#echo "enter input file name:"
#read inputdata
#echo "enter name of the new file that will be created with md5checksum added column:"
#read inputdatamd5

awk -v OFS=',' '{
    cmd = "echo \047" $0 "\047 | md5sum"
    val = ( (cmd | getline line) > 0 ? line : "FAILED")
    close(cmd)
    sub(/ .*/,"",val)
    print $0, val
}' Patches.csv > Patchesmd5.csv


headr_m=$(awk -F, 'NR == 1 { print $9 }' Patchesmd5.csv)
sed -i -e '1s/'$headr_m'/md5sum/' Patchesmd5.csv


CWD="$(pwd)"

url=$1
sha=$2
od_test=$3

#for f in $(find $project -name .csv ); do cat $f; done > final-csv-file-that-you-are-generating-with-a-script.csv
 
#for f in $(cat some-csv-file-from-command-line.csv); do bash some-other-script.sh $f; done
 
#for f in $(cat Patchesmd5.csv | sort -u); do
#dt=$(echo $f | cut -d',' -f6)   
  
#md5sum=$(grep $url Patchesmd5.csv | grep $sha | grep $od_test | cut -d, -f9)
bash newlatestfindOD.sh "$url" "$sha" "$od_test"
#done
