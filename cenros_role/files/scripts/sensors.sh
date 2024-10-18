#!/bin/bash

# sensors | grep "coretemp-isa-0001" -A 5 | grep "Core" | awk '{print $3}' | grep -o -E "[0-9][0-9]"
################################################################################


################################################################################

temp_core(){
    # local filestat="${1}"
    local result=$( sensors | grep "coretemp-isa-0000" -A 2 | grep "Core" | awk '{print $3}' | grep -o -E "[0-9][0-9]" )
    echo "${result}"
}


###################################################################################

main() {
    ACTION=${1:-get_items}

    case "$ACTION" in
    "temp_core")
        temp_core
    ;;
    *)
        zbxnotsupported
    ;;
    esac
}

main "$@"

