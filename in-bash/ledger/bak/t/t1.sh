clear
echo "특정일의 총 지출액 계산 테스트"
DAY='01.01'
echo "특정일의 지출 내역 전체를 출력"
_extract_payments_of_day ${DAY} | cat
echo "특정일의 지출 금액만 임시 파일에 저장"
_extract_payments_of_day ${DAY} | cut -f3 > ${TMP_DIR}/${TMP_FILE}
echo "특정일의 지출 금액 총합 계산"
(cat ${TMP_DIR}/${TMP_FILE} | tr '\012' '+'; echo "0") | bc
_print_empty_line
