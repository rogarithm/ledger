#!/usr/bin/env bash

SOURCE_DIR='/Users/sehun/personal/ledger'
SOURCE_FILE='2023-01.txt'
TMP_DIR='tmp'
TMP_FILE='range'
DAY=$1

if [ ! -d ${TMP_DIR}/${TMP_FILE} ]; then
	touch ${TMP_DIR}/${TMP_FILE}
fi

START_DATE='01.01'
END_DATE='01.04'
DATES_FILE='dates'
dates () {
	if [ ! -d ${TMP_DIR}/${DATES_FILE} ]; then
		touch ${TMP_DIR}/${DATES_FILE}
	fi

	echo ${START_DATE} >> ${TMP_DIR}/${DATES_FILE}

	while [ "${START_DATE}" != "${END_DATE}" ]; do
		echo "START: " ${START_DATE}
		START_DATE=$(date -j -f '%m.%d' -v+1d ${START_DATE} +%m.%d)
		echo ${START_DATE} >> ${TMP_DIR}/${DATES_FILE}
	done

	while read DATE; do
		echo "${DATE}"
	done < ${TMP_DIR}/${DATES_FILE}
}

range () {
	gsed -e '1d' ${SOURCE_DIR}/${SOURCE_FILE} | gsed -e '/^$/d' | gsed 's/ | /\t/g' | grep -e $1
}

_print_empty_line () {
	echo
}

# 테스트
clear
range ${DAY} | cat # 특정일의 지출 내역 전체를 출력
_print_empty_line
range ${DAY} | cut -f3 > ${TMP_DIR}/${TMP_FILE} # 특정일의 지출 금액만 임시 파일에 저장
(cat ${TMP_DIR}/${TMP_FILE} | tr '\012' '+'; echo "0") | bc # 특정일의 지출 금액 총합 계산
_print_empty_line
dates # 시작일과 종료일 사이(inclusive) 날짜를 임시 파일에 저장
_print_empty_line
while read DATE; do # 임시 파일에 저장된 날짜 모두에 대해 지출 내역 전체를 출력
	range ${DATE} | cat
done < ${TMP_DIR}/${DATES_FILE}
