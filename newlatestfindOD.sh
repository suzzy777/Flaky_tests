#!/bin/bash
#set -x
#echo "script vers: $(git rev-parse HEAD)"
#echo "start time: $(date)"

#git config --global user.name "suzzy777"
#git config --global user.email "suzzanarafi@gmail.com"

$1
$2
$3
#$4

#smalldata=$1
#smalldatamd5=$2
#echo "enter input file name:"
#read inputdata
#echo "enter name of the new file that will be created with md5checksum added column:"
#read inputdatamd5



CWD="$(pwd)"

#for f in $(cat smalltest.csv); do

echo "==========="
#echo $f
url=$1
sha=$2
od_test=$3
#md5sum=$4
#abc=$(grep $od_test Patchesmd5.csv | cut -d, -f6 )


#ab=$(awk -v od="$od_test" -F, '$4 == od { print $6 }' Patchesmd5.csv)
echo "$ab"
#for polluter in $(grep $od_test Patchesmd5.csv | cut -d, -f6 | sort -u); do
ab=$(awk -v od="$od_test" -F, '$4 == od { print $6 }' Patchesmd5.csv | sort -u)
echo "SORT";echo "$ab"
for polluter in $ab;do
    echo "POLLUTER:============================================================================"
    echo "$polluter";echo "---------------------------"
    #cd=$(awk -v key=$polluter '$6 == key { print $7 }' Patchesmd5.csv)
    cd=$(awk -v key="$polluter" -F, '$6 == key { print $7 }' Patchesmd5.csv)
    echo "$cd"
    if [ "$cd" == "" ];then
	
	cd="EMPTY"
    fi
    #if ($(grep $polluter)
    #for cleaner in $((grep $od_test Patchesmd5.csv | grep $polluter Patchesmd5.csv) | cut -d, -f7 | sort -u); do
    for cleaner in $cd;do
	echo "OD TEST:";echo "$od_test";echo "POLLUTER:";echo "$polluter";
	echo "CLEANER:"
	echo "$cleaner"
        
      	echo "######################################################"
	if [ "$cleaner" == "EMPTY" ];then
	    
	    project=$(awk -F, '$4 == "'"$od_test"'" && $6 == "'"$polluter"'" { print $1}' Patchesmd5.csv)                             
	    md5=$(awk -F, '$4 == "'"$od_test"'" && $6 == "'"$polluter"'" { print $9}' Patchesmd5.csv)                                 
	   #pro
	    patch=$(awk -F, '$4 == "'"$od_test"'" && $6 == "'"$polluter"'" { print $8}' Patchesmd5.csv)
	else
	    
	#	md5=$(awk -F',' '$4 == "authnzerver/tests/test_auth_creation.py::test_create_user" && $6 == "authnzerver/tests/test_auth_login.py::test_login" && $7 == "authnzerver/tests/test_auth_deletesessions.py::test_sessions_delete_userid" { print $9 }' Patchesmd5.csv)
           
	#	"'"$a"'"
	    project=$(awk -F, '$4 == "'"$od_test"'" && $6 == "'"$polluter"'" && $7 == "'"$cleaner"'" { print $1}' Patchesmd5.csv)         
	    md5=$(awk -F, '$4 == "'"$od_test"'" && $6 == "'"$polluter"'" && $7 == "'"$cleaner"'" { print $9}' Patchesmd5.csv)
	    patch=$(awk -F, '$4 == "'"$od_test"'" && $6 == "'"$polluter"'" && $7 == "'"$cleaner"'" { print $8}' Patchesmd5.csv)                          
	#md5sum=$(echo $f | cut -d',' -f9)                                             
	fi

 
	#awk -v key="#$polluter" -F, '$6 == key { print $7 }' Patchesmd5.csv && awk -v key="$polluter" -F, '$6 == key { p#rint $ }' Patchesmd5.cs

	echo $od_test;echo $polluter;echo $cleaner;echo $patch;echo $md5;                                                                                    # $pollu#ter Patchesmd5.csv | grep $cleaner Patchesmd5.csv | cut -d, -f9)
 #      echo $cleaner  #patch_name=$(grep $project Patches.csv | grep $sha | grep $od_test | grep $dtecho $md5
                                                                                   
	                                                                               
   #	 if [[ "Project_Name" == "$project" ]]; then continue; fi;                     
	                                                                               
	 #if [[ "" == "$patch_name" ]]; then continue; fi;                             
	#patch=$(echo $patch_name | cut -d',' -f8)                                     
	 #BT-Tracker/ipflakies_result/d94526b0/patch/test_event_patch_91e72946.patch   
	 #patch_path=$(echo $patch | cut -d'/' -f2-3)                                  

#	patch_final=$(echo $patch | rev | cut -d'/' -f1 | rev)                        

	#test_event_patch_91e72946.patch                                              
	                                                                               
	                                                                               
	#echo $patch_name                                                              
	    #echo $patch                                                                   
	# echo "Patch:"                                                                
	 # echo $patch_final
    done
done    
