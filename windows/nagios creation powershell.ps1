$list = import-csv \\file-1\itresources$\Scripts\nagios.csv

foreach ($item in $list){
     "define service{"
        "     use                     normal-p"
        "     hostgroup_name          Switch"
		"     host_name  			UKLONSW001,UKLONL2SW001"
        "     service_description     Check Powerconenct: " + $item.name
        "     check_command           check_powerconnect!" + $item.name

     "}"
    }
