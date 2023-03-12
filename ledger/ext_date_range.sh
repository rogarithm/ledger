#!/usr/bin/env bash

start_at=$1
end_at=$2

extract_dates_in_range () {

	result=${start_at}
	while [ "${start_at}" != "${end_at}" ]; do
		start_at=$(date -j -f '%m.%d' -v+1d ${start_at} +%m.%d)
		result="$result:${start_at}"
	done

	echo "$result"
	exit 0
}

extract_dates_in_range $start_at $end_at
