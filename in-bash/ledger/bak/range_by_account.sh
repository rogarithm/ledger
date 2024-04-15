#!/usr/bin/env bash

TMP_DIR='/tmp'

DATES_FILE='dates_in_range'
_extract_dates_in_range () {
	local start_date=$1
	local end_date=$2

	if [ ! -d ${TMP_DIR}/${DATES_FILE} ]; then # 지출 기간 내 날짜 정보 모을 파일 없으면 생성
		touch ${TMP_DIR}/${DATES_FILE}
	fi

	cat /dev/null > ${TMP_DIR}/${DATES_FILE} # 이전에 파일에 쓴 값 지우기

	echo ${start_date} >> ${TMP_DIR}/${DATES_FILE} # 기간 내 날짜를 파일에 쓰기
	while [ "${start_date}" != "${end_date}" ]; do
		start_date=$(date -j -f '%m.%d' -v+1d ${start_date} +%m.%d)
		echo ${start_date} >> ${TMP_DIR}/${DATES_FILE}
	done
}

_extract_payments_of_day () {
	local source_dir='/Users/sehun/personal/ledger'
	local source_file='2023-01.txt'

	# 헤더인 첫 줄을 삭제 -> 빈 줄을 삭제 -> 구분자를 탭 문자로 치환 -> 날짜로 지출 내역 검색
	# -> 계좌로 지출 내역 검색
	gsed -e '1d' ${source_dir}/${source_file} | \
		gsed -e '/^$/d' | \
		gsed 's/ | /\t/g' | \
		grep -e $1 | \
		grep -e $2
}

compute_total_amounts_in_range () {
	local filtered_payments='payments_in_range'
	local start_date=$1
	local end_date=$2
	local account=$3

	if [ ! -d ${TMP_DIR}/${filtered_payments} ]; then # 지출 내역 모을 파일 없으면 생성
		touch ${TMP_DIR}/${filtered_payments}
	fi

	_extract_dates_in_range ${start_date} ${end_date}

	cat /dev/null > ${TMP_DIR}/${filtered_payments} # 이전에 파일에 쓴 값 지우기

	while read date; do
		if [ ${date} ]; then
			_extract_payments_of_day ${date} ${account} | cut -f3 >> ${TMP_DIR}/${filtered_payments} # 지출 내역에서 금액만 추출
		fi
	done < ${TMP_DIR}/${DATES_FILE}

	(cat ${TMP_DIR}/${filtered_payments} | tr '\012' '+'; echo "0") | bc
}


compute_total_amounts_in_range $1 $2 $3
