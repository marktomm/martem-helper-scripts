#!/bin/bash

# inteded input file is gw/Gateway6/source/Core2/System/settingdescriptions.cpp
# Outputs mediawiki three column table format: argument, default value, description

set -eo pipefail

main() {
    local source_file=/home/mark/Development/telem-cloner/next/gw/Gateway6/source/Core2/System/settingdescriptions.cpp
    
    grep "^[\t ]*(\"[a-z]" "${source_file}" | 
        awk 'BEGIN { FS = "," } ;  
            /default_value/{ printf $1 " " $2 " " $3  "\n" } ;
            !/default_value/{ printf $1 " " $2 "\n" }' |
        sed 's/^[\t ]*("\([^"]*\)".*default_value([\t ]*"\?\([^"]*\)"\?[\t ]*)[\t ]*"\([^"]*\)"\?.*/|-\n| \1 \n| \2 \n| \3/g' |
        sed '/default_value/!s/^[ \t]*("\([^"]*\)".*"\([^"]*\)".*/|-\n| \1 \n| -\n| \2/g' |
        sed '/default_value/!s/^[ \t]*("\([^"]*\)"[\t ]*\(value.*()\)/|-\n| \1 \n| -\n| \2/g' |
        sed '/timezone.default/d'
        
    grep "^[\t ]*(\"[a-z]" "${source_file}" | grep -F 'timezone.default' | 
        sed 's/^[\t ]*("\([^"]*\)".*default_value([\t ]*"\?\([^"]*\)"),[\t ]*"\([^"]*\)"\?.*/|-\n| \1 \n| \2 \n| \3/g'
}

main