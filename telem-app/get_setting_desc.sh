#!/bin/bash

# inteded input file is gw/Gateway6/source/Core2/System/settingdescriptions.cpp
# Outputs mediawiki three column table format: argument, default value, description

set -eo pipefail

main() {
    local source_file=/home/mark/Development/telem-cloner/next/gw/Gateway6/source/Core2/System/settingdescriptions.cpp
        
    while read line; do
        [[ ${line} =~ \(\"[a-z] ]] && {
            line=$(echo ${line} | 
                tr -s " " |             # squeeze whitespace
                sed 's/^[\t ]*//')      # remove any whitespace from start
            
            [[ ${line} =~ value\<[_\ a-zA-Z0-9:]*\>\(\) ]] && {
                local argument=$(echo ${line%% *} | sed 's/^("\([-a-zA-Z.]*\).*$/\1/')
                local description=$(echo ${line##* \"} | sed 's/\(^[- \ta-zA-Z0-9*.,:;/\()!?_]*\)"[\t ]\?)[\t ]\?$/\1/')
                local pseudo_default=$(echo ${line#*, } | sed 's/\(^value.*\)), .*$/\1/')
                [[ ${pseudo_default} =~ default_value ]] && {
                    local default=$(echo ${pseudo_default#*default_value\(} | sed 's/^"\?\(.*\)"[\t ]\?$/\1/')
                } || {
                    local default=$(echo ${pseudo_default} | sed 's/^value<[\t ]\?\([_a-zA-Z0-9:]*\)[\t ]\?>.*$/\1/')
                }
            } || {
                local argument=$(echo ${line} | sed 's/("\([-a-zA-Z0-9.]*\)".*$/\1/')
                local description=$(echo ${line} | sed 's/^.*, "\([- \ta-zA-Z0-9*.,:;/\()!?_]*\)").*$/\1/')
                local default="N/A"
            }
            echo '|-'
            echo "| ${argument}"
            echo "| ${default}"
            echo "| ${description}"
            # http://www.thegeekstuff.com/2010/07/bash-string-manipulation
            # https://www.networkworld.com/article/2693361/unix-tip-using-bash-s-regular-expressions.html
        }
    done < ${source_file}
}

main