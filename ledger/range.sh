#!/usr/bin/env bash

SOURCE_DIR='/Users/sehun/personal/ledger'
SOURCE_FILE='2023-01.txt'
TMP_DIR='tmp'
TMP_FILE='range'
DAY=$1

if [ ! -d ${TMP_DIR}/${TMP_FILE} ]; then
	touch ${TMP_DIR}/${TMP_FILE}
fi

range () {
	gsed -e '1d' ${SOURCE_DIR}/${SOURCE_FILE} | gsed -e '/^$/d' | gsed 's/ | /\t/g' | grep -e ${DAY} | cut -f3 > ${TMP_DIR}/${TMP_FILE}
}

clear
printRange () {
	gsed -e '1d' ${SOURCE_DIR}/${SOURCE_FILE} | gsed -e '/^$/d' | gsed 's/ | /\t/g' | grep -e ${DAY} | cat
}
echo
(cat ${TMP_DIR}/${TMP_FILE} | tr '\012' '+'; echo "0") | bc

#cat ${TMP_DIR}/${TMP_FILE}
