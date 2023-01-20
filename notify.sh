#!/usr/bin/env bash

LEDGER="/Users/sehun/personal/ledger/$(date -v -1d "+%Y-%m").txt"
RESULT=$(grep -e "^$(date -v -1d "+%m.%d")" ${LEDGER})
YESTERDAY=$(date -v -1d "+%m.%d")

if [ -z ${RESULT} ] ; then
	echo display notification \"어제 \(${YESTERDAY}\) 지출 내역을 작성하지 않으셨네요. \" with title \"가계부\"  | osascript
fi
