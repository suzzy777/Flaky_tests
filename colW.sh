#set -x
for f in $(cat PatchesNew2.csv); do
    #echo "=============================="
    project=$(echo $f | cut -d, -f1)
    if [[ "$project" == "Project_Name" ]]; then continue; fi
    
    od_test=$(echo $f | cut -d, -f3)
    
    if [[ "$od_test" == "AfterPatch_Isolation_result" ]]; then continue; fi
    if [[ "$od_test" == "Did_patch_work" ]]; then continue; fi
    
    od_type=$(echo $f | cut -d, -f4)
    isbrittlefailing=$(echo $f | cut -d, -f8)
    isvictimfailing=$(echo $f | cut -d, -f9)
    isodflaky=$(echo $f | cut -d, -f10)
    bpiso=$(echo $f | cut -d, -f11)
    bpdt=$(echo $f | cut -d, -f12)
    bpod=$(echo $f | cut -d, -f13)
    apiso=$(echo $f | cut -d, -f14)
    apdt=$(echo $f | cut -d, -f15)
    apod=$(echo $f | cut -d, -f16)

    
    #if [[ "$project" == "Project_Name" ]]; then continue; fi
    
    

    
#    echo "OD type:"
 #   echo "$project"
  #  echo "$od_test"
   # echo "$od_type"
   # echo "is B failing:"
   # echo "$isbrittlefailing"
   # echo "is V failing:"
   # echo "$isvictimfailing"
   # echo "BP iso:"
   # echo "$bpiso"
   # echo "BP dt:"
   # echo "$bpdt"
   # echo "BP od:"
   # echo "$bpod"
   # echo "AP iso:"
   # echo "$apiso"
   # echo "AP dt:"
   # echo "$apdt"
   # echo "AP OD:"
   # echo "$apod"

    #didpatchwork=$(echo $f | cut -d, -f23)
    if [[ "$od_type" == "brittle" ]] && [[ "$isbrittlefailing" == "TRUE" ]] && [[ "$apiso" == "passed" ]]
    then
	didpatchwork="TRUE"
	#echo "DID PATCH WORK:"
	#echo $didpatchwork
    elif [[ "$od_type" == "brittle" ]] && [[ "$isbrittlefailing" == "TRUE" ]] && [[ "$apiso" == "failed" ]]
    then
	didpatchwork="FALSE"
#	echo "DID PATCH WORK:"
#	echo $didpatchwork
     elif [[ "$od_type" == "victim" ]] && [[ "$isvictimfailing" == "TRUE" ]] && [[ "$apod" == "passed" ]]
     then
	didpatchwork="TRUE"
	#echo "DID PATCH WORK:"
	#echo $didpatchwork
     elif [[ "$od_type" == "victim" ]] && [[ "$isvictimfailing" == "TRUE" ]] && [[ "$apod" == "failed" ]]
     then
	didpatchwork="FALSE"
	#echo "DID PATCH WORK:"
	#echo $didpatchwork
     elif [[ "$isodflaky" == "TRUE" ]] && [[ "$apiso" == "ERROR" ]] && [[ "$apdt" == "ERROR" ]] && [[ "$apod" == "ERROR" ]]
     then
	didpatchwork="ERROR_after_patching"
	#echo "DID PATCH WORK:"
	#echo $didpatchwork
     elif [[ "$isodflaky" == "ERROR" ]] 
     then
	didpatchwork="ERROR"
	#echo "DID PATCH WORK:"
	#echo $didpatchwork

     elif [[ "$isodflaky" == "FALSE" ]] 
     then
	didpatchwork="Was_not_OD"
	#echo "DID PATCH WORK:"
	#echo $didpatchwork
     elif [[ "$isodflaky" == "Repository_not_found" ]] 
     then
	didpatchwork="Repository_not_found"
	#echo "DID PATCH WORK:"
	#echo $didpatchwork

    fi
    
   

    echo "$didpatchwork"
done
    #IF(OR((AND(E3="brittle",N3=TRUE,T3="passed")),(AND(E3="victim",O3=TRUE,V3="passed"))),TRUE,FALSE)
