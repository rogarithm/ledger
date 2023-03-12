#!/usr/bin/env bash
dates=$(cat - | gsed 's/:/\n/g') # 표준 입력으로부터 읽는다
ledger='/Users/sehun/personal/ledger/2023.txt'

result=''
for date in $dates; do
	pay=$(gsed -e '1d' $ledger | \
		gsed -e '/^$/d' | \
		gsed 's/ | /\t/g' | \
		grep -e $date | \
		head -n1)
	result="$result:$pay"
done

echo "$result" | sed 's/^://' # 맨 앞 : 문자 삭제
exit 0
