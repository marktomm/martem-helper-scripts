#!/bin/bash

#####################################################################################################################################
#
# Usage: ./addr2line backtrace_file unstripped_source
# Example: ./addr2line.sh p_addr2line.txt ~/Projects/telem-cloner/sissegv-handler/build-telem-gw6e-vmx53/build/telem-gw-custom/source
#
# backtrace_file content example:
# telem-gw[0x1c14f4]
# telem-gw[0x1c1730]
# /lib/libc.so.6(__default_sa_restorer_v2+0x0)[0x2b107820]
# telem-gw[0x2e3f0]
# telem-gw[0x88860]
# telem-gw[0xb9c64]
# telem-gw[0xb39d8]
# telem-gw[0xbd978]
# telem-gw[0xc72ac]
# telem-gw[0xc7554]
# telem-gw[0x36208]
# /usr/lib/libboost_thread.so.1.52.0(+0xf30c)[0x2ac8b30c]
#
# file with segfault backtrace is usually /var/log/telem/telem-gw-stderr in device
#
# unstripped_source file has to be an unstripped duplicate of telem-gw that is running in the device.
# Our source.pro files has -g -ggdb compiler arguments enabled, so buildroot builds a debugable
# binary in its build direcotry and puts the stripped version in the target directory.
#
#####################################################################################################################################

BACKTRACE_FILE=$1
BINARY_FILE=$2

C_PURPLE=$'\033[0;35m'
C_GREEN=$'\033[0;32m'
C_NOCOL=$'\033[0m' # No Color


sed 's/.*\[\(.*\)\].*/\1/g' ${BACKTRACE_FILE} | while read line
do
  a2l_output=$(addr2line $line -f -C -e ${BINARY_FILE})
  case $a2l_output in
    *"??"*)
      ;;
    *)
      sed "s/\([^/]*\)\(\/.*\)\(:[0-9]*\)/${C_PURPLE}\1${C_NOCOL}\n\2${C_GREEN}\3${C_NOCOL}/g" <<< ${a2l_output}
  esac
done
