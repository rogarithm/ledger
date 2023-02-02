#!/usr/bin/env bash

TMP_DIR='/tmp'

START_DATE=$1
END_DATE=$2
DATES_FILE='dates_in_range'
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

compute_total_amounts_in_range () {
	local tmp_file='payments_in_range'

	if [ ! -d ${TMP_DIR}/${tmp_file} ]; then
		touch ${TMP_DIR}/${tmp_file}
	fi

	_extract_dates_in_range $1 $2

	cat /dev/null > ${TMP_DIR}/${tmp_file}

	while read DATE; do
		if [ ${DATE} ]; then
			_extract_payments_of_day ${DATE} | cut -f3 >> ${TMP_DIR}/${tmp_file}
		fi
	done < ${TMP_DIR}/${DATES_FILE}

	(cat ${TMP_DIR}/${tmp_file} | tr '\012' '+'; echo "0") | bc
}


compute_total_amounts_in_range
