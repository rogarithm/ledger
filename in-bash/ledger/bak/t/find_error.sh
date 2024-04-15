echo $1
echo $(../lefts.sh ${1}) '+' $(../range_by_account.sh 01.01 $2 ${1}) | bc
