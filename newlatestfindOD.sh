#!/bin/bash
set -x
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
#echo "$ab"
#for polluter in $(grep $od_test Patchesmd5.csv | cut -d, -f6 | sort -u); do
if [ grep -q $od_test Patchesmd5.csv ];then
    
    ab=$(awk -v od="$od_test" -F, '$4 == od { print $6 }' Patchesmd5.csv | sort -u)
    echo "SORT";echo "$ab"
    
    for dt in $ab;do
	echo "POLLUTER:============================================================================"
	echo "$dt";echo "---------------------------"
	#cd=$(awk -v key=$polluter '$6 == key { print $7 }' Patchesmd5.csv)
	cd=$(awk -v key="$dt" -F, '$6 == key { print $7 }' Patchesmd5.csv)
	echo "$cd"

	if [ "$cd" == "" ];then
	    
	    cd="EMPTY"
	fi
	#if ($(grep $polluter)
	#for cleaner in $((grep $od_test Patchesmd5.csv | grep $polluter Patchesmd5.csv) | cut -d, -f7 | sort -u); do
	for cleaner in $cd;do
	    echo "OD TEST:";echo "$od_test";echo "POLLUTER:";echo "$dt";
	    echo "CLEANER:"
	    echo "$cleaner"
            
      	    echo "######################################################"
	    if [ "$cleaner" == "EMPTY" ];then
		
		project=$(awk -F, '$4 == "'"$od_test"'" && $6 == "'"$dt"'" { print $1}' Patchesmd5.csv)                             
		md5sum=$(awk -F, '$4 == "'"$od_test"'" && $6 == "'"$dt"'" { print $9}' Patchesmd5.csv)                                 
		#pro
		patch=$(awk -F, '$4 == "'"$od_test"'" && $6 == "'"$dt"'" { print $8}' Patchesmd5.csv)
		od_type=$(awk -F, '$4 == "'"$od_test"'" && $6 == "'"$dt"'" { print $5}' Patchesmd5.csv)
	    else
		
		#	md5=$(awk -F',' '$4 == "authnzerver/tests/test_auth_creation.py::test_create_user" && $6 == "authnzerver/tests/test_auth_login.py::test_login" && $7 == "authnzerver/tests/test_auth_deletesessions.py::test_sessions_delete_userid" { print $9 }' Patchesmd5.csv)
		
		#	"'"$a"'"
		project=$(awk -F, '$4 == "'"$od_test"'" && $6 == "'"$dt"'" && $7 == "'"$cleaner"'" { print $1}' Patchesmd5.csv)         
		md5sum=$(awk -F, '$4 == "'"$od_test"'" && $6 == "'"$dt"'" && $7 == "'"$cleaner"'" { print $9}' Patchesmd5.csv)
		patch=$(awk -F, '$4 == "'"$od_test"'" && $6 == "'"$dt"'" && $7 == "'"$cleaner"'" { print $8}' Patchesmd5.csv)
		od_type=$(awk -F, '$4 == "'"$od_test"'" && $6 == "'"$dt"'" && $7 == "'"$cleaner"'" { print $5}' Patchesmd5.csv)
		#md5sum=$(echo $f | cut -d',' -f9)                                             
	    fi

	    
	    #awk -v key="#$polluter" -F, '$6 == key { print $7 }' Patchesmd5.csv && awk -v key="$polluter" -F, '$6 == key { p#rint $ }' Patchesmd5.cs

	    patch_final=$(echo $patch | rev | cut -d'/' -f1 | rev)

	    echo $od_test;echo $od_type;echo $dt;echo $cleaner;echo $patch;echo $md5;                                                                                    # $pollu#ter Patchesmd5.csv | grep $cleaner Patchesmd5.csv | cut -d, -f9)
	    #      echo $cleaner  #patch_name=$(grep $project Patches.csv | grep $sha | grep $od_test | grep $dtecho $md5
	    
	    git clone $url
	    cd $project
	    
	    virtualenv venv
	    source venv/bin/activate

	    pip install pytest
	    pip install pytest-csv
	    #sudo apt-get install csvkit
	    #sudo apt-get install hub
	    
	    pipfile freeze -o
	    pip install -U -r requirements.txt
	    pip install -U -r test_requirements.txt
	    pip install -U -r requirements-dev.txt
	    pip install -U -r test-requirements.txt
	    pip install -U -r requirements-docs.txt
	    pip install -U -r optional-requirements.txt
	    pip install -U -r requirements-pip.txt
	    pip install -U -r requirements-test.txt
	    pip install .

	    
	    od_file_name=$(echo $od_test | cut -d':' -f1)
	    #od_file_name= Tracker/tests/test_event.py
	    # yp.tneve_tset/stset/..
	    od_file=$(echo $od_file_name | rev | cut -d'/' -f1 | rev)
	    #yp.tneve_tset
	    #test_event.py
	    # Tracker/tests/test_event.py::TestEvent::test_object
	    file_loc=$(echo $od_file_name | rev | cut -d'/' -f2- | rev)
	    #Tracker/tests

	    #git checkout -- $od_file_name
	    
	    #naming the files
	    od_test_name=$(echo $od_test | rev | cut -d':' -f1 | rev)
	    dependent_test_name=$(echo $dt | rev | cut -d':' -f1 | rev)

	    psha="$(git rev-parse HEAD)"
	    echo "================ $project current sha: $psha"
	    # > $folder"_sha".log
	    shadate="$(git show -s --format=%ct $psha)"
	    echo "================ $project sha date:  $shadate"


	    #testing if OD

	    python3 -m pytest $od_test --csv $md5sum"_before_patch_isolation".csv |& tee $md5sum"_before_patch_isolation".log
	    python3 -m pytest $dt $od_test --csv $md5sum"_before_patch".csv |& tee $md5sum"_before_patch".log

	    #headbeforeadd=$(git rev-parse HEAD)
	    echo "-----------------------BP----:"
	    
	    #for g in $(cat  $project"_"$od_test_name"_before_patch_isolation".csv); do
	    
	    isolationResultBP=$(csvformat -q "'" -T $md5sum"_before_patch_isolation".csv | cut -d $'\t' -f7 | head -n 2| tail -n 1)
	    echo "=============================================================================ISOBP:"
	    echo $isolationResultBP

	    #dtodResultBP=$(cut $project"_"$dependent_test_name"_"$od_test_name"_before_patch".csv  -d',' -f1,7| tail -n 2)
	    
	    dtResultBP=$(csvformat -q "'" -T $md5sum"_before_patch".csv | cut -d $'\t' -f7 | head -n 2| tail -n 1)
	    echo "===============================================================================DTBP:"
	    echo $dtResultBP

	    odResultBP=$(csvformat -q "'" -T $md5sum"_before_patch".csv | cut -d $'\t' -f7 | head -n 3| tail -n 1)
	    echo "===============================================================================ODBP:"
	    echo $odResultBP
	    #cd $CWD

	    if [[ ("victim" == "$od_type") && ("passed" == "$isolationResultBP") && ("failed" == "$odResultBP") || ("brittle" == "$od_type") && ("failed" == "$isolationResultBP") && ("passed" == "$odResultBP") ]];then
		
		echo "=========================================================================================================PATCHING"
		#patch_name=$(grep $project Patches.csv | grep $sha | grep $od_test | grep $dt | grep $od_type)
	      #if [ grep -q $od_test Patchesmd5.csv ];then
		    
		    
		    
	        cp -r /mnt/batch/tasks/workitems/DRR_delay-tmp_r0_6M10d9h55m28s/job-1/Flaky_tests/ipflakies_result/$patch /mnt/batch/tasks/workitems/DRR_delay-tmp_r0_6M10d9h55m28s/job-1/Flaky_tests/$project/$file_loc/
		    
		CWD2="$(pwd)"
		
		cd $file_loc
		echo "File Location: "$file_loc""

		CWD3="$(pwd)"
		
		patch -N $od_file $patch_final

		cd "$CWD2"

		python3 -m pytest $od_test --csv $md5sum"_after_patch_isolation".csv | tee $md5sum"_after_patch_isolation".log
		python3 -m pytest $dt $od_test --csv $md5sum"_after_patch".csv | tee $md5sum"_after_patch".log
		
		echo "-----------------------AP----:"
		
		isolationResultAP=$(csvformat -q "'" -T $md5sum"_after_patch_isolation".csv | cut -d $'\t' -f7 | head -n 2| tail -n 1)
		echo "=============================================================================ISOAP:"
		echo $isolationResultAP
		
		dtResultAP=$(csvformat -q "'" -T $md5sum"_after_patch".csv | cut -d $'\t' -f7 | head -n 2| tail -n 1)
		echo "===============================================================================DTAP:"
		
		echo $dtResultAP

		odResultAP=$(csvformat -q "'" -T $md5sum"_after_patch".csv | cut -d $'\t' -f7 | head -n 3| tail -n 1)
		echo "===============================================================================ODAP:"
		echo $odResultAP
		echo $(git rev-parse HEAD)

		if [[ ("victim" == "$od_type") && ("passed" == "$odResultAP") ||  ("brittle" == "$od_type") && ("passed" == "$isolationResultAP") ]];then
		    sevenmd5=${md5sum:0:7}
		    seven="${sevenmd5}branchb"
		    # headbeforeadd=$(git rev-parse HEAD)
		    #user=suzzy777
		    #	git init

		    
		    
		    git status
		    #git remote add $user git@github.com:/suzzy777/$project.git
		    #https://github.com/suzzy777/$project.git
		    #git remote add upstream git@github.com:suzzy777/pysllo.git
  		    hub fork
		    #ln $od_file_name
		    #cynergy/tests/test_class_mapping.py
		    
		    git add $od_file_name
		    git checkout -b "$seven"
		    git commit -m "Fix flaky test"
		    #echo "Insert github username:"
		    read -p "user"
		    git push -u $user "$seven"
		    #CWD3="$(pwd)"
		    #echo "$CWD3" 
		    # git request-pull master ./
		    # git checkout $headbeforeadd -- $od_file_name
		    # cd $CWD2
		    if [[ "victim" == "$od_type" ]]; then 

			#echo "===========================ENTERING LOOP:"
			echo -e "## What is the purpose of the change: \n - This PR is to fix a flaky test \`$od_test\`, which can fail after running the polluter : \n \`$dt\`, but passes when it is run in isolation. \n ## Reproduce the test failure: \n - Run the following command: \n  \`python -m pytest \`$dt\` \`$od_test\` \n - This command can be used with the above mentioned polluter and the order dependent test - \`$od_test\` \n ## Expected Result: \n - Test \`$od_test\` should pass when run after test \`$dt\` \n ## Actual Result: \n - Test \`$od_test\` fails when it is run after the test \`$dt\` \n ## Why the test fails: \n - The flaky test fails because the test is dependent on some state thats being changed by the polluters. \n ## Fix: \n - The changes in this pull request cleans the state polluted by the polluter and makes the flaky test pass."
	    		

		    elif [[ "brittle" == "$od_type" ]]; then
			     
			     #echo "===========================ENTERING LOOP:"
			     echo -e "## What is the purpose of the change: \n - This PR is to fix a flaky test \`$od_test\`, which can fail while running in isolation but passes when run after a state-setter: \n \`$dt\`. \n ## Reproduce the test failure: \n - Run the following commands: \n	\`python -m pytest $od_test\` \n \`python -m pytest $dt $od_test\` \n  - These commands can be used with the above mentioned state-setter and the order dependent test  - \`$od_test\` \n ## Expected Result: \n - Test \`$od_test\` should pass when run both in isolation and after \`$dt\` \n ## Actual Result: \n - Test \`$od_test\` fails when it is run in isolation, but passes when run after \`$dt\` \n ## Why the test fails: \n - The flaky test fails because the test is dependent on some state that is not set when it is run in isolation. \n ## Fix: \n - The changes in this pull request sets the state and makes the flaky test pass."
			     
			     
		    fi
			 

		fi
		    
	    
		
	    else
		echo "===============================Did not need to  patch"
		isolationResultAP="No After Patch File"
		echo "ISOAP:"
		echo $isolationResultAP
		dtResultAP="No After Patch File"
		echo "DTAP:"
		echo $dtResultAP	
		odResultAP="No After Patch File"
		echo "ODAP:"
		echo $odResultAP
		
	    fi	

	    cd $file_loc
	    patch -R -p1 $od_file < $patch_final
	    #git checkout $headbeforeadd -- $od_file
	    #git checkout "$seven" -- $od_file
	    
	    cd "$CWD"


	    echo "end time:"
	    date

	    echo "================================================================Project details: $f, Current SHA: $psha, Before Patch Isolation Result: $isolationResultBP, Before Patch DT Result: $dtResultBP, Before Patch OD Result: $odResultBP, After Patch Isolation Result: $isolationResultAP, After Patch DT Result: $dtResultAP, After Patch OD Result: $odResultAP, SHA Date (Unix Epoch time): $shadate"

        
  
	done
    done  
else
    pip install ipflakies
    python3 -m ipflakies -i 30 --seed=202114
    list=$(find . -name 'minimized.json')
    for s in $list;do
	#od_type=$(cat $s | jq -r '.type')
	#od_test=
	temp=$(grep -Po '"tests/test_loading.py::test_loading":.*?[^\\]",' flakies.json)
	if [ grep -q "$od_test" $temp ];then
	    echo "yes"
	  
	    python3 -m ipflakies -t $od_test        

	    list2=$(find . -name '*.patch')
	    for p in $list2;do
		cp -r $p ./$file_loc
		#patch_n=$(find . -name $od_test"_patch_*"
		patch_n=$(find . -name '$od_test_patch_*.patch')  
		patch $od_file $patch_n
            done
	else
	    echo "no"
     done
     
	    
	    
	    
	    