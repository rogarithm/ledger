clear
echo "기간 내 날짜 목록 추출 테스트"
echo "시작일과 종료일 사이(inclusive) 날짜를 임시 파일에 저장"
_extract_dates_in_range
_print_empty_line
echo "기간 내 지출 내역 추출 테스트"
echo "기간 내 모든 지출 내역을 출력"
while read DATE; do
	if [ ${DATE} ]; then
		_extract_payments_of_day ${DATE} | cat
	fi
done < ${TMP_DIR}/${DATES_FILE}
echo "기간 내 지출 금액만 임시 파일에 저장"
echo "우선 특정일 지출액 계산 시 임시 파일에 입력한 내용 삭제"
cat /dev/null > ${TMP_DIR}/${TMP_FILE}
while read DATE; do
	if [ ${DATE} ]; then
		_extract_payments_of_day ${DATE} | cut -f3 >> ${TMP_DIR}/${TMP_FILE}
	fi
done < ${TMP_DIR}/${DATES_FILE}
echo "임시 파일에 저장한 기간 내 지출 금액 확인"
cat ${TMP_DIR}/${TMP_FILE}
echo "기간 내 지출 금액 총합 계산"
(cat ${TMP_DIR}/${TMP_FILE} | tr '\012' '+'; echo "0") | bc
