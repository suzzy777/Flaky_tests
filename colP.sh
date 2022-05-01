#set -x
for f in $(cat PatchesNew2.csv); do
    #echo "=============================="
    project=$(echo $f | cut -d, -f1)
    if [[ "$project" == "Project_Name" ]]; then continue; fi
    
    od_test=$(echo $f | cut -d, -f3)
    
    if [[ "$od_test" == "AfterPatch_Isolation_result" ]]; then continue; fi
    if [[ "$od_test" == "Did_patch_work" ]]; then continue; fi
    od_type=$(echo $f | cut -d, -f4)
    #N
    isbrittlefailing=$(echo $f | cut -d, -f8)
    #O
    isvictimfailing=$(echo $f | cut -d, -f9)
    isodflaky=$(echo $f | cut -d, -f10)
    bpiso=$(echo $f | cut -d, -f11)
    bpdt=$(echo $f | cut -d, -f12)
    bpod=$(echo $f | cut -d, -f13)
    apiso=$(echo $f | cut -d, -f14)
    apdt=$(echo $f | cut -d, -f15)
    apod=$(echo $f | cut -d, -f16)
    #echo "$project"
    #echo "$od_test"
    #didpatchwork=$(echo $f | cut -d, -f23)
    if [[ "$isbrittlefailing" == "TRUE" ]] || [[ "$isvictimfailing" == "TRUE" ]]
    then
	isodflaky="TRUE"
	#echo "DID PATCH WORK:"
	#echo $didpatchwork
    elif [[ "$isbrittlefailing" == "ERROR" ]] && [[ "$isvictimfailing" == "ERROR" ]]
    then
	isodflaky="ERROR"
#	echo "DID PATCH WORK:"
#	echo $didpatchwork
    elif [[ "$isbrittlefailing" == "Repository_not_found" ]] && [[ "$isvictimfailing" == "Repository_not_found" ]]
    then
	isodflaky="Repository_not_found"
    else
	isodflaky="FALSE"

    fi
    
   

    echo "$isodflaky"
done



  # =IF(OR(N2=TRUE,O2=TRUE),TRUE,IF(AND(N2="ERROR",O2="ERROR"),"ERROR",IF(AND(N2="Repository_not_found",O2="Repository_not_found"),"Repository_not_found",FALSE))) 
