set -x
CWD="$(pwd)"
for f in $(cat zula.csv);do
    echo "==========="
    echo $f
    project=$(echo

	      $f | cut -d',' -f1)
    url=$(echo $f | cut -d',' -f2)
    sha=$(echo $f | cut -d',' -f3)
    od_test=$(echo $f | cut -d',' -f4)
    #od_type=$(echo $f | cut -d',' -f5)
    #dt=$(echo $f | cut -d',' -f6)
    #patch_name=$(echo $f | cut -d',' -f8)
    #md5sum=$(echo $f | cut -d',' -f9)
    

    #patch_name=$(grep $project Patches.csv | grep $sha | grep $od_test | grep $dt | grep $od_type)
   

    if [[ "Project_Name" == "$project" ]]; then continue; fi;

    git clone $url
    cd $project
    
    virtualenv venv
    source venv/bin/activate

    #pip install pytest
    #pip install pytest-csv
    #sudo apt-get install csvkit
    #sudo apt-get install hub
    pip install ipflakies
    
    #pipfile freeze -o
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
    
    python3 -m ipflakies -i 100 -t $od_test
done    
