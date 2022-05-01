set -x
cd flaky
git config --global user.name "suzzy777"
git config --global user.email "suzzanarafi@gmail.com"
git init
echo "script vers: $(git rev-parse HEAD)"
echo "start time: $(date)"


CWD="$(pwd)"
echo $CWD
for f in $(cat pw2_final.csv); do
    echo "==========="
    #echo $f
    project=$(echo $f | cut -d, -f1)
    patch_work=$(echo $f | cut -d, -f3)
    od_test=$(echo $f | cut -d',' -f2)
   # hdr1==$(echo $f | cut -d',' -f16)
   # hdr2==$(echo $f | cut -d',' -f19)
    
    #if [[ "Before Patch" == "$hdr1" ]]; then continue; fi;
    #if [[ "After Patch" == "$hdr2" ]]; then continue; fi;
    if [[ "Project_Name" == "$project" ]]; then continue; fi;

    od_file_name=$(echo $od_test | cut -d':' -f1)
    #od_file_name= Tracker/tests/test_event.py
    # yp.tneve_tset/stset/..
    od_file=$(echo $od_file_name | rev | cut -d'/' -f1 | rev)
    #yp.tneve_tset
    #test_event.py
    # Tracker/tests/test_event.py::TestEvent::test_object
    file_loc=$(echo $od_file_name | rev | cut -d'/' -f2- | rev)
    #Tracker/tests
    CWD2="$(pwd)"
    echo "$CWD2" 
    if [[ "TRUE" == "$patch_work" ]]; then
	
	cd all_folders/$project
	user=suzzy777
	git init
        git remote add $user git@github.com:/suzzy777/$project.git
	#https://github.com/suzzy777/$project.git
        #git remote add upstream git@github.com:suzzy777/pysllo.git
	hub fork
	ln $od_file_name
	#cynergy/tests/test_class_mapping.py
	git add $od_file
	git checkout -b newbranch
	git commit -m "fix flaky test"
	git push -u $user newbranch
	CWD3="$(pwd)"
	echo "$CWD3" 
	git request-pull master ./
	cd $CWD2
      fi

    #echo "Did patch work?"
    #echo $patch_work
 done

