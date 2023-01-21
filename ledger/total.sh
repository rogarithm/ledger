#!/usr/bin/env bash

SOURCE_DIR='/Users/sehun/personal/ledger'
SOURCE_FILE='2023-01.txt'
TMP_DIR='tmp'
TMP_FILE='total'

touch ${TMP_DIR}/${TMP_FILE}

gsed -e '1d' ${SOURCE_DIR}/${SOURCE_FILE} | gsed -e '/^$/d' | gsed 's/ | /\t/g' | cut -f3 > ${TMP_DIR}/${TMP_FILE}

(cat ${TMP_DIR}/${TMP_FILE} | tr '\012' '+'; echo "0") | bc

#cat ${TMP_DIR}/${TMP_FILE}
