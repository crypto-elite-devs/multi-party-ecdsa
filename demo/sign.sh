#!/usr/bin/env bash
cargo +nightly build --examples --release

file_as_string=`cat params.json`

n=`echo "$file_as_string" | cut -d "\"" -f 4 `
t=`echo "$file_as_string" | cut -d "\"" -f 8 `

echo "Multi-party ECDSA parties:$n threshold:$t"
#clean
sleep 1

killall gg18_sm_manager gg18_keygen_client gg18_sign_client 2> /dev/null

./target/release/examples/gg18_sm_manager &

sleep 5
echo "sign"

for i in $(seq 1 $((t+1)));
do
    echo "signing for client $i out of $((t+1))"
    ./target/release/examples/gg18_sign_client http://127.0.0.1:8000 keys$i.store "KZen Networks" &
    sleep 3
done

killall gg18_sm_manager 2> /dev/null
