#!/usr/bin/env bash
cargo +nightly build --examples --release

file_as_string=`cat params.json`

n=`echo "$file_as_string" | cut -d "\"" -f 4 `
t=`echo "$file_as_string" | cut -d "\"" -f 8 `

echo "Multi-party ECDSA parties:$n threshold:$t"
#clean
sleep 1

rm keys?.store
killall gg18_sm_manager gg18_keygen_client gg18_sign_client 2> /dev/null

./target/release/examples/gg18_sm_manager &

sleep 2
echo "keygen part"

for i in $(seq 1 $n)
do
    echo "key gen for client $i out of $n"
    ./target/release/examples/gg18_keygen_client http://127.0.0.1:8000 keys$i.store &
    sleep 3
done

killall gg18_sm_manager 2> /dev/null
