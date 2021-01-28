#!/usr/bin/env bash

set -e

RPC_URI=${1:-"http://127.0.0.1:8545"}

get_last_block_number(){
    HEIGHT=$(set -e; curl -s -X POST -H "Content-Type: application/json" \
        -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
        ${RPC_URI} |jq -re .result)
    echo $HEIGHT
}

until [ "$(get_last_block_number)" == "0x0" ] ; do
  echo "Attempt to get eth_blockNumber from "$RPC_URI
  sleep 1
done

echo SUCCESS
