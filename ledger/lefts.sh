#!/usr/bin/env bash

compute_left () {
	local source_dir='/Users/sehun/personal/ledger'
	local source_file='left_12_31.txt'
	local arg=$1

	if [ $arg ]; then
		(cat ${source_dir}/${source_file} | grep -e "^${arg}:" | cut -d: -f2 | tr '\012' '+'; echo "0") | bc
		exit 0;
	else
		(cat ${source_dir}/${source_file} | cut -d: -f2 | tr '\012' '+'; echo "0") | bc
		exit 0;
	fi
}

compute_left $1
