set -x
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

awk -v OFS=',' '{
    cmd = "echo \047" $0 "\047 | md5sum"
    val = ( (cmd | getline line) > 0 ? line : "FAILED")
    close(cmd)
    sub(/ .*/,"",val)
    print $0, val
}' smalldataset.csv > smalldatamd5.csv


headr_m=$(awk -F, 'NR == 1 { print $9 }' smalldatamd5.csv)
sed -i -e '1s/'$headr_m'/md5sum/'   smalldatamd5.csv


CWD="$(pwd)"

for f in $(cat smalldatamd5.csv); do

    echo "==========="
    echo $f
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


    echo $patch_name
    echo $patch
   # echo "Patch:"
   # echo $patch_final

   # if [[ "" == "$patch" ]]; then continue; fi;
 
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

	cp -r /home/$USER/ipflakies_result/$patch /home/$USER/$project/$file_loc
   
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

	    flag=1
		
	    if [[ "$flag" == 1 ]];then

		    echo -e "Do you want to fork the repository and push the changes?\nIf so, type 'yes'.\n Or else, type 'no'"
		    read command
	    fi

            if [[ "yes" == "$command" ]];then

        #if [[ ("victim" == "$od_type") && ("passed" == "$odResultAP") ||  ("brittle" == "$od_type") && ("passed" == "$isolationResultAP") ]];then
		sevenmd5=${md5sum:0:7}
		seven="${sevenmd5}branchb"
	  
  		hub fork
	#ln $od_file_name
	    #cynergy/tests/test_class_mapping.py
	   
		git add $od_file_name
		git checkout -b "$seven"
		git commit -m "Fix flaky test"
		echo "Insert github username to create a remote repository:"
		read user
		git push -u $user "$seven"
	   
		if [[ "victim" == "$od_type" ]]; then
		

                #echo "===========================ENTERING LOOP:"
	            echo -e "## What is the purpose of the change: \n - This PR is to fix a flaky test \`$od_test\`, which can fail after running the polluter : \n \`$dt\`, but passes when it is run in isolation. \n ## Reproduce the test failure: \n - Run the following command: \n  \`python -m pytest $dt $od_test \n - This command can be used with the above mentioned polluter and the order dependent test - \`$od_test\` \n ## Expected Result: \n - Test \`$od_test\` should pass when run after test \`$dt\` \n ## Actual Result: \n - Test \`$od_test\` fails when it is run after the test \`$dt\` \n ## Why the test fails: \n - The flaky test fails because the test is dependent on some state thats being changed by the polluters. \n ## Fix: \n - The changes in this pull request cleans the state polluted by the polluter and makes the flaky test pass."
	    		              

		elif [[ "brittle" == "$od_type" ]]; then
		      #echo "===========================ENTERING LOOP:"
		    echo -e "## What is the purpose of the change: \n - This PR is to fix a flaky test \`$od_test\`, which can fail while running in isolation but passes when run after a state-setter: \n \`$dt\`. \n ## Reproduce the test failure: \n - Run the following commands: \n	\`python -m pytest $od_test\` \n \`python -m pytest $dt $od_test\` \n  - These commands can be used with the above mentioned state-setter and the order dependent test  - \`$od_test\` \n ## Expected Result: \n - Test \`$od_test\` should pass when run both in isolation and after \`$dt\` \n ## Actual Result: \n - Test \`$od_test\` fails when it is run in isolation, but passes when run after \`$dt\` \n ## Why the test fails: \n - The flaky test fails because the test is dependent on some state that is not set when it is run in isolation. \n ## Fix: \n - The changes in this pull request sets the state and makes the flaky test pass."
		      
		
		fi

            
            fi
	             	 
	               

        fi
		 
    
	
    else
	echo "===============================Did not need to  patch"
	isolationResultAP="No After Patch File"
	echo "ISOBP:"
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










    
   
