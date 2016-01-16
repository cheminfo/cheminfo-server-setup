USED_DISK_ALERT=70
USED_MEM_ALERT=70
USED_PROC_ALERT=50

function freeMemory() {
	message "free memory"
	usedMem=`free | grep Mem | awk '{print int($3/$2 * 100)}'`
	if
		[ $usedMem -le $USED_MEM_ALERT ]
	then
		ok
		return 0
	else
		error	
		info "Running out of memory space ($usedMem% used)"
		return 1
	fi
}

function freeProc() {
	message "processor activity"
	usedProc=`top -bn2 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | tail -1 | awk '{print int(100 - $1)}'`
	if
		[ $usedProc -le $USED_PROC_ALERT ]
	then
		ok
		return 0
	else
		error	
		info "Running out of processor ($usedProc% used)"
		return 1
	fi
}

function checkDiskSpace() {
	message "disk space"
	status=0
	while read line
	do
		usePercentage=$(echo $line | awk '{ print $1}' | cut -d'%' -f1  )
		partition=$(echo $line | awk '{ print $2 }' )
		if [ $usePercentage -ge $USED_DISK_ALERT ]; then
			if
				[ $status -eq 0 ]
			then
				error
			fi
			info "Running out of space $partition ($usePercentage%)"
			status=1
		fi
	done <<< "$(df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }')"
	if
		[ $status -eq 0 ]
	then
		ok
	fi
	return $status
}

