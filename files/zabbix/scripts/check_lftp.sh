#!/bin/bash

get_status(){
    result=$(ps aux | grep -v grep | grep -c "/usr/bin/lftp")
    echo ${result}
}

fn_kill_lftp(){
    /usr/bin/sudo killall lftp
}
###################################################################################

main() {
ACTION=${1:-get_items}

  case "$ACTION" in
    "status")
	get_status
    ;;
    "kill_lftp")
	fn_kill_lftp
    ;;
    *)
	zbxnotsupported
    ;;
  esac
}

main "$@"