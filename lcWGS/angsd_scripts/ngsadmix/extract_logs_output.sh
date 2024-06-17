OUTPUT=$1 
grep -Po 'like=\K[^ ]+' $OUTPUT > "logs_"$OUTPUT
