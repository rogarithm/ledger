#!/usr/bin/env bash
dates=$(cat -) # 표준 입력으로부터 읽는다
ledger='/Users/sehun/personal/finance/2023.txt'

result=''
for date in $dates; do
	pay=$(gsed -e '1d' $ledger | \
		gsed -e '/^$/d' | \
		gsed 's/ | /\t/g' | \
		grep -e $date)
	result="$result:$pay"
done
# 맨 앞 : 문자 삭제 후 구분자를 \n로 변환
echo "$result" | sed 's/^://' | gsed 's/:/\n/g'
exit 0
