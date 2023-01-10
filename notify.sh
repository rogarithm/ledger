#!/usr/bin/env bash

LEDGER="/Users/sehun/personal/ledger/$(date -v -1d "+%Y-%m").txt"
RESULT=$(grep -e "^$(date -v -1d "+%m.%d")" ${LEDGER})

if [ -z ${RESULT} ] ; then
	osascript -e 'display notification "어제 지출 내역을 작성하지 않으셨네요." with title "가계부"'
fi
