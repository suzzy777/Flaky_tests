#set -x
for f in $(cat PatchesNew2.csv); do
    #echo "=============================="
    project=$(echo $f | cut -d, -f1)
    if [[ "$project" == "Project_Name" ]]; then continue; fi
    
    od_test=$(echo $f | cut -d, -f3)
    
    if [[ "$od_test" == "AfterPatch_Isolation_result" ]]; then continue; fi
    if [[ "$od_test" == "Did_patch_work" ]]; then continue; fi

    #E
    od_type=$(echo $f | cut -d, -f4)
    #N
    isbrittlefailing=$(echo $f | cut -d, -f8)
    #O
    isvictimfailing=$(echo $f | cut -d, -f9)
    #P
    isodflaky=$(echo $f | cut -d, -f10)
    #Q
    bpiso=$(echo $f | cut -d, -f11)
    #R
    bpdt=$(echo $f | cut -d, -f12)
    #S
    bpod=$(echo $f | cut -d, -f13)
    #T
    apiso=$(echo $f | cut -d, -f14)
    #U
    apdt=$(echo $f | cut -d, -f15)
    #V
    apod=$(echo $f | cut -d, -f16)
    #echo "$project"
    #echo "$od_test"


    
    # =IF(AND(E2="victim",Q2="passed",S2="failed"),TRUE,IF(AND(Q2="ERROR",R2="ERROR",S2="ERROR"),"ERROR",IF(Q2="Repository_not_found","Repository_not_found",FALSE)))

    #=IF(AND(E2 = "brittle",Q2="Failed"),TRUE,FALSE)
    if [[ "$od_type" == "brittle" ]] && [[ "$bpiso" == "failed" ]]
    then
	isbfailing="TRUE"
	
    elif [[ "$bpiso" == "ERROR" ]] && [[ "$bpdt" == "ERROR" ]] && [[ "$bpod" == "ERROR" ]]
    then
	isbfailing="ERROR"
	
    elif [[ "$bpiso" == "Repository_not_found" ]]
    then
	isbfailing="Repository_not_found"
    else
	isbfailing="FALSE"

    fi
    
   

    echo "$isvictimfailing"
done



