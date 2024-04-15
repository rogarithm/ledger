#!/usr/bin/env bash
payments=$(cat - | gsed -e '/^$/d') # 빈 줄이 생길 수 있다

#echo "$payments"
(echo "$payments" | cut -f3 | tr '\n' '+'; echo "0") | bc
