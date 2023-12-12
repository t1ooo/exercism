clear
for i in $(find ./ -iname '*_test.sh'); do
    echo "$i"
    echo ""
    bats "$i"
done
