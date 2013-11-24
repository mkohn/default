#!/bin/sh
NIMBLE="10.0.6.20"

#hard coded varibles
STATE_OK=0
STATE_CRITICAL=2
STATE_UNKNOWN=3
ProblemVolumes=""
VOL=`ssh admin@$NIMBLE /nimble/usr/bin/vol --list | sed '1,4d' | awk '{print $1}' | sed  ':a;N;$!ba;s/\n/ /g'`


for i in $VOL;  do
        
	#gets the data
	ssh admin@`echo $NIMBLE` /nimble/usr/bin/vol --info $i > /tmp/nimble-vol

	#goes into the datastore and gets all the info
	volsize="`cat /tmp/nimble-vol |grep -w \"Size\" |awk '{print $3}' `"
	volwarn="`cat /tmp/nimble-vol |grep -w \"Warn level\" |awk '{print $3}'|cut -d "%" -f1|cut -d "." -f1 `"
	
	#does some calculatiosn about the colume size
	volwarnn=`echo $volsize*0.$volwarn|bc|cut -d "." -f1`
	volusage="`cat /tmp/nimble-vol |grep -w \"Volume usage\" |awk '{print $4}' `"
	WARN=`echo $volwarnn*1024*1024|bc`
	
	#does the cechking
	if  [ "$volusage" -gt "$WARN" ]; then
		ProblemVolumes="$ProblemVolumes `echo $i`"
	elif [ "$volusage" -le "$WARN" ]; then
		#did this to not kill the nimble device 
		sleep 1
	else
               	echo "UNKNOWN" $check
                exit $STATE_UNKNOWN
     	fi
done

#checks if problem volumes exist
if ["$ProblemVolumes" = ""]; then
	echo "All volumes ok"
	exit $STATE_OK
else
	echo "Datastores with Problems: "  $ProblemVolumes
	exit $STATE_CRITICAL
fi
