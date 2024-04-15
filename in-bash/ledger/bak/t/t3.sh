#echo left range
#echo kakao
#echo $(../lefts.sh 'kakao')
#echo $(../range_by_account.sh 01.01 02.24 'kakao')
#echo eum
#echo $(../lefts.sh 'eum')
#echo $(../range_by_account.sh 01.01 02.24 'eum')
#echo shinhan
#echo $(../lefts.sh 'shinhan')
#echo $(../range_by_account.sh 01.01 02.24 'shinhan')
echo safebox
echo $(../lefts.sh 'safebox') '+' $(../range_by_account.sh 01.01 02.28 'safebox') | bc
echo kakao
echo $(../lefts.sh 'kakao') '+' $(../range_by_account.sh 01.01 02.28 'kakao') | bc
echo shinhan
echo $(../lefts.sh 'shinhan') '+' $(../range_by_account.sh 01.01 02.28 'shinhan') | bc
echo ibk
echo $(../lefts.sh 'ibk') '+' $(../range_by_account.sh 01.01 02.28 'ibk') | bc
echo eum
echo $(../lefts.sh 'eum') '+' $(../range_by_account.sh 01.01 02.28 'eum') | bc
echo kakaopay
echo $(../lefts.sh 'kakaopay') '+' $(../range_by_account.sh 01.01 02.28 'kakaopay') | bc
