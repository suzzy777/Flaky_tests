set -x
echo "script vers: $(git rev-parse HEAD)"
echo "start time: $(date)"

awk -v OFS=',' '{
    cmd = "echo \047" $0 "\047 | md5sum"
    val = ( (cmd | getline line) > 0 ? line : "FAILED")
    close(cmd)
    sub(/ .*/,"",val)
    print $0, val
}' Patches.csv > md5.csv

headr_m=$(awk -F, 'NR == 1 { print $9 }'   md5.csv)
sed -i -e '1s/'$headr_m'/md5sum/'   md5.csv

CWD="$(pwd)"
for f in $(cat md5.csv); do
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
    
    virtualenv mvenv
    source mvenv/bin/activate

    pip install pytest
    pip install pytest-csv
    
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
    

    #testing if OD
    python3 -m pytest $od_test --csv $md5sum"_before_patch_isolation".csv |& tee $md5sum"_before_patch_isolation".log
    python3 -m pytest $dt $od_test --csv $md5sum"_before_patch".csv |& tee $md5sum"_before_patch".log

    echo "-----------------------BP----:"

    #for g in $(cat  $project"_"$od_test_name"_before_patch_isolation".csv); do
	
    isolationResultBP=$(csvformat -q "'" -T $md5sum"_before_patch_isolation".csv | cut -d $'\t' -f1,7 | head -n 2| tail -n 1)
    echo $isolationResultBP

    #dtodResultBP=$(cut $project"_"$dependent_test_name"_"$od_test_name"_before_patch".csv  -d',' -f1,7| tail -n 2)
    
    dtodResultBP=$(csvformat -q "'" -T $md5sum"_before_patch".csv | cut -d $'\t' -f1,7 | head -n 3| tail -n 2)

    echo $dtodResultBP
   
   	
	
    psha="$(git rev-parse HEAD)"
    echo "================ $project sha: $psha"
    # > $folder"_sha".log
    shadate="$(git show -s --format=%ct $psha)"
    echo "================ $project sha date:  $shadate"

    #patching
    
    cp -r /home/suzzana/ipflakies_result/$patch /home/suzzana/$project/$file_loc
    #cp -r /home/suzzana/ipflakies_result/$patch /home/suzzana/$file_loc
    
    CWD2="$(pwd)"
    
    cd $file_loc
    echo "File Location: "$file_loc""

    CWD3="$(pwd)"
    
    patch -N $od_file $patch_final

    cd "$CWD2"

    python3 -m pytest $od_test --csv $md5sum"_after_patch_isolation".csv | tee $md5sum"_after_patch_isolation".log
    python3 -m pytest $dt $od_test --csv $md5sum"_after_patch".csv | tee $md5sum"_after_patch".log
    
    echo "-----------------------AP----:"
    
    isolationResultAP=$(csvformat -q "'" -T $md5sum"_after_patch_isolation".csv | cut -d $'\t' -f1,7 | head -n 2| tail -n 1)
    echo $isolationResultAP


    # dtodResultAP=$(cut $project"_"$dependent_test_name"_"$od_test_name"_after_patch".csv  -d',' -f1,7| tail -n 2)
    
    dtodResultAP=$(csvformat -q "'" -T $md5sum"_after_patch".csv | cut -d $'\t' -f1,7 | head -n 3| tail -n 2)
    echo $dtodResultAP

    #time
    
    echo "$(date)"|& tee time.log

    cd "$CWD3"
    git checkout -- $od_file
    
    cd "$CWD"


    echo "end time:"
    date

    echo "================================================================Project details: $f, SHA: $psha, Before Patch Isolation Result: $isolationResultBP, Before Patch DT-OD Result: $dtodResultBP, After Patch Isolation Result: $isolationResultAP, After Patch DT-OD Result: $dtodResultAP, SHA Date (Unix Epoch time): $shadate"

done










    
   
