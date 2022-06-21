#!/bin/bash
#set -x
echo "script vers: $(git rev-parse HEAD)"
echo "start time: $(date)"

#git config --global user.name "suzzy777"
#git config --global user.email "suzzanarafi@gmail.com"

#$1
#$2

#smalldata=$1
#smalldatamd5=$2
#echo "enter input file name:"
#read inputdata
#echo "enter name of the new file that will be created with md5checksum added column:"
#read inputdatamd5


CWD="$(pwd)"

for f in $(cat Patches_that_work.csv); do

    echo "==========="
    #echo $f
    project=$(echo $f | cut -d',' -f1)
    url=$(echo $f | cut -d',' -f2)
    sha=$(echo $f | cut -d',' -f3)
    od_test=$(echo $f | cut -d',' -f4)
    od_type=$(echo $f | cut -d',' -f5)
    dt=$(echo $f | cut -d',' -f6)
    patch_name=$(echo $f | cut -d',' -f8)
    md5sum=$(echo $f | cut -d',' -f9)
    

    #patch_name=$(grep $project Patches.csv | grep $sha | grep $od_test | grep $dt | grep $od_type)
   

    if [[ "Project_Name" == "$project" ]]; then continue; fi;
    
    #if [[ "" == "$patch_name" ]]; then continue; fi;
    
    patch=$(echo $patch_name | cut -d',' -f8)
    #BT-Tracker/ipflakies_result/d94526b0/patch/test_event_patch_91e72946.patch
    #patch_path=$(echo $patch | cut -d'/' -f2-3)
    patch_final=$(echo $patch | rev | cut -d'/' -f1 | rev)
    #test_event_patch_91e72946.patch


    #echo $patch_name
    #echo $patch
   # echo "Patch:"
   # echo $patch_final

   # if [[ "" == "$patch" ]]; then continue; fi;
 
   
    getsha=$(cat logfinal2.log | grep "Project details" | grep "$od_test" | grep -o 'SHA:[^;]*' |  cut -d',' -f1 | sort -u)
    echo $project,$od_test,$getsha 
 done
