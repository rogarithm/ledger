#!/usr/bin/env bash
payments=$(cat - | gsed 's/:/\n/g' | gsed -e '/^$/d') # 빈 줄이 생길 수 있다

#echo "$payments"
(echo "$payments" | cut -f3 | tr '\012' '+'; echo "0") | bc
