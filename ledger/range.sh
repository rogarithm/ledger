#!/usr/bin/env bash

TMP_DIR='/tmp'
TMP_FILE='range'

if [ ! -d ${TMP_DIR}/${TMP_FILE} ]; then
	touch ${TMP_DIR}/${TMP_FILE}
fi

START_DATE=$1
END_DATE=$2
DATES_FILE='dates'
_extract_dates_in_range () {
	if [ ! -d ${TMP_DIR}/${DATES_FILE} ]; then
		touch ${TMP_DIR}/${DATES_FILE}
	fi

	cat /dev/null > ${TMP_DIR}/${DATES_FILE}
	echo ${START_DATE} >> ${TMP_DIR}/${DATES_FILE}

	while [ "${START_DATE}" != "${END_DATE}" ]; do
		START_DATE=$(date -j -f '%m.%d' -v+1d ${START_DATE} +%m.%d)
		echo ${START_DATE} >> ${TMP_DIR}/${DATES_FILE}
	done
}

_extract_payments_of_day () {
	local source_dir='/Users/sehun/personal/ledger'
	local source_file='2023-01.txt'
	gsed -e '1d' ${source_dir}/${source_file} | gsed -e '/^$/d' | gsed 's/ | /\t/g' | grep -e $1
}

_print_empty_line () {
	echo
}



compute_total_amounts_in_range () {
	_extract_dates_in_range $1 $2

	cat /dev/null > ${TMP_DIR}/${TMP_FILE}

	while read DATE; do
		if [ ${DATE} ]; then
			_extract_payments_of_day ${DATE} | cut -f3 >> ${TMP_DIR}/${TMP_FILE}
		fi
	done < ${TMP_DIR}/${DATES_FILE}

	(cat ${TMP_DIR}/${TMP_FILE} | tr '\012' '+'; echo "0") | bc
}


compute_total_amounts_in_range
