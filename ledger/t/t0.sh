#!/usr/bin/env bash

path='/Users/sehun/tools/finance/ledger'
tmp_dir='/tmp'
dates_file='dates_in_range'
payments_file='payments_in_range'


cat /dev/null > ${tmp_dir}/${dates_file}
cat /dev/null > ${tmp_dir}/${payments_file}
cd ${path}
./range.sh 01.01 01.20
