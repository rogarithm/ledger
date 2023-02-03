#!/usr/bin/env bash

TMP_DIR='/tmp'

DATES_FILE='dates_in_range'
_extract_dates_in_range () {
	local start_date=$1
	local end_date=$2

	if [ ! -d ${TMP_DIR}/${DATES_FILE} ]; then
		touch ${TMP_DIR}/${DATES_FILE}
	fi

	cat /dev/null > ${TMP_DIR}/${DATES_FILE}
	echo ${start_date} >> ${TMP_DIR}/${DATES_FILE}

	while [ "${start_date}" != "${end_date}" ]; do
		start_date=$(date -j -f '%m.%d' -v+1d ${start_date} +%m.%d)
		echo ${start_date} >> ${TMP_DIR}/${DATES_FILE}
	done
}

_extract_payments_of_day () {
	local source_dir='/Users/sehun/personal/ledger'
	local source_file='2023-01.txt'

	gsed -e '1d' ${source_dir}/${source_file} | gsed -e '/^$/d' | gsed 's/ | /\t/g' | grep -e $1
}

compute_total_amounts_in_range () {
	local filtered_payments='payments_in_range'
	local start_date=$1
	local end_date=$2

	if [ ! -d ${TMP_DIR}/${filtered_payments} ]; then
		touch ${TMP_DIR}/${filtered_payments}
	fi

	_extract_dates_in_range ${start_date} ${end_date}

	cat /dev/null > ${TMP_DIR}/${filtered_payments}

	while read date; do
		if [ ${date} ]; then
			_extract_payments_of_day ${date} | cut -f3 >> ${TMP_DIR}/${filtered_payments}
		fi
	done < ${TMP_DIR}/${DATES_FILE}

	(cat ${TMP_DIR}/${filtered_payments} | tr '\012' '+'; echo "0") | bc
}


compute_total_amounts_in_range $1 $2
