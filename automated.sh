#set -x
#echo "script vers: $(git rev-parse HEAD)"
#echo "start time: $(date)"

#dir=$1
#md5=$2
#$1
#input=$1
CWD=$(pwd)

read input
for f in $(cat "$input"); do

    project=$(echo $f | cut -d, -f1)

    if [[ "Project_Name" == "$project" ]]; then bpr="Before_Patch_Isolation";dbpr="Before_Patch_DT";bbpr="Before_Patch_OD";apr="After_Patch_Isolation";abpr="After_Patch_DT";aapr="After_Patch_OD"; echo $f,$bpr,$dbpr,$bbpr,$apr,$abpr,$aapr; cd "$CWD" ; continue; fi;

    dir=$project
    
    md5_sha=$(echo $f | cut -d, -f9)
    #1b1578f929265ba188ba3c55db833b6a_after_patch.csv
    od_test_name=$(echo $f | cut -d, -f4)
    dt_test_name=$(echo $f | cut -d, -f6)
    
    if [ ! -d "$dir" ]; then bpr="Repository_not_found";dbpr="Repository_not_found";bbpr="Repository_not_found";apr="Repository_not_found";abpr="Repository_not_found";aapr="Repository_not_found"; echo $f,$bpr,$dbpr,$bbpr,$apr,$abpr,$aapr; cd "$CWD" ; continue; fi;
   
    bpi=$(find $dir -name "${md5_sha}_before_patch_isolation.csv")
    bpf=$(find $dir -name "${md5_sha}_before_patch.csv")
    api=$(find $dir -name "${md5_sha}_after_patch_isolation.csv")
    apf=$(find $dir -name "${md5_sha}_after_patch.csv")


   

    if [[ "$bpi" == "" ]]; then
	#continue;
	bpr="ERROR"
    else
	bpr=$(grep -F "$od_test_name", $bpi | cut -d, -f7)

	   
	#abpr=$(grep ^$dt_test_name, $apf | cut -d, -f7)
	#echo $f,"BP ISOLATION OD:"$bpr""
    fi

    #echo "============================="
    
    if [[ "$bpf" == "" ]]; then
	bbpr="ERROR"
	dbpr="ERROR"
	#continue;
    else
	bbpr=$(grep -F "$od_test_name", $bpf | cut -d, -f7)
	dbpr=$(grep -F "$dt_test_name", $bpf | cut -d, -f7)
	#echo $f,"BP DT:"$dbpr"","OD:"$bbpr""
    fi

    #echo "============================="

    
    
    if [[ "$api" == "" ]]; then
	apr="ERROR"
	#continue;
    else
	apr=$(grep -F "$od_test_name", $api | cut -d, -f7)
	#abpr=$(grep ^$dt_test_name, $apf | cut -d, -f7)
	#echo $f,"AP ISOLATION OD:"$apr""
    fi

    #echo "============================="


    
    if [[ "$apf" == "" ]]; then
	aapr="ERROR"
	abpr="ERROR"
	#continue;
    else
	aapr=$(grep -F "$od_test_name", $apf | cut -d, -f7)
	abpr=$(grep -F "$dt_test_name", $apf | cut -d, -f7)
	#echo $f,"AP DT:"$abpr"","OD:"$aapr""

    fi

    if [[ "passed" == "$bpr" ]] && [[ "passed" == "$bbpr" ]] && [[ "passed" == "$dbpr" ]];then
	apr="Was_not_OD"
	aapr="Was_not_OD"
	abpr="Was_not_OD"
    fi
    
    echo $f,$bpr,$dbpr,$bbpr,$apr,$abpr,$aapr
    cd "$CWD"
    #echo "======================================================================="
 
done
