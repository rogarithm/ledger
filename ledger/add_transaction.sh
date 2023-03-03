#!/usr/bin/env bash

source_dir='/Users/sehun/personal/ledger'
source_file='2023.txt'

#date가 입력 형식과 다르면 다시 입력하도록
#입력 안했을 때 오늘 날짜로 입력되도록
/bin/echo 'date: \c'
read date_unformatted
date=$(date -j -f '%m.%d' -v+0d $date_unformatted +%m.%d)

/bin/echo 'description: \c'
read description

/bin/echo 'amount: \c'
read amount

#자동완성할 수 없나? 또는 가능한 목록 보여주기
/bin/echo 'category: \c'
read category

#자동완성할 수 없나? 또는 가능한 목록 보여주기
/bin/echo 'account: \c'
read account

echo "$date | $description | $amount | $category |  | $account" >> ${source_dir}/${source_file}
