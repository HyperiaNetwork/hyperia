#!/bin/bash

BINARY=$1
CONTINUE=${CONTINUE:-"false"}
HOME_DIR=mytestnet
ENV=${ENV:-""}

if [ "$CONTINUE" == "true" ]; then
    $BINARY start --home $HOME_DIR --log_level debug
    exit 0
fi

rm -rf mytestnet
pkill -9 hyperiad

# check DENOM is set. If not, set to uhype
DENOM=${2:-uhype}

COMMISSION_RATE=0.01
COMMISSION_MAX_RATE=0.02

SED_BINARY=sed
# check if this is OS X
if [[ "$OSTYPE" == "darwin"* ]]; then
    # check if gsed is installed
    if ! command -v gsed &> /dev/null
    then
        echo "gsed could not be found. Please install it with 'brew install gnu-sed'"
        exit
    else
        SED_BINARY=gsed
    fi
fi

# check BINARY is set. If not, build hyperiad and set BINARY
if [ -z "$BINARY" ]; then
    make build
    BINARY=build/hyperiad
fi

CHAIN_ID="local-hype"
KEYRING="test"
KEY="test0"

# Function updates the config based on a jq argument as a string
update_test_genesis () {
    # update_test_genesis '.consensus_params["block"]["max_gas"]="100000000"'
    cat $HOME_DIR/config/genesis.json | jq "$1" > $HOME_DIR/config/tmp_genesis.json && mv $HOME_DIR/config/tmp_genesis.json $HOME_DIR/config/genesis.json
}

$BINARY init --chain-id $CHAIN_ID moniker --home $HOME_DIR
$BINARY keys add $KEY --keyring-backend $KEYRING --home $HOME_DIR
# Allocate genesis accounts (cosmos formatted addresses)
$BINARY genesis add-genesis-account $KEY "1000000000000000${DENOM}" --keyring-backend $KEYRING --home $HOME_DIR

update_test_genesis '.app_state["gov"]["voting_params"]["voting_period"]="15s"'
update_test_genesis '.app_state["gov"]["deposit_params"]["min_deposit"]=[{"denom":"'$DENOM'","amount": "1000000"}]'
update_test_genesis '.app_state["gov"]["params"]["min_deposit"]=[{"denom":"'$DENOM'","amount": "1000000"}]'
update_test_genesis '.app_state["gov"]["params"]["expedited_min_deposit"]=[{"denom":"'$DENOM'","amount": "50000000"}]'
# update_test_genesis '.app_state["tokenfactory"]["params"]["denom_creation_fee"]=[{"denom":"'$DENOM'","amount": "1000000"}]'
update_test_genesis '.app_state["tokenfactory"]["params"]["denom_creation_fee"]=[]'
update_test_genesis '.app_state["tokenfactory"]["params"]["denom_creation_gas_consume"]=2000000'
update_test_genesis '.app_state["feemarket"]["params"]["fee_denom"]="'$DENOM'"'
update_test_genesis '.app_state["mint"]["params"]["mint_denom"]="'$DENOM'"'
update_test_genesis '.app_state["crisis"]["constant_fee"]={"denom":"'$DENOM'","amount":"1000"}'
update_test_genesis '.app_state["staking"]["params"]["bond_denom"]="'$DENOM'"'

# enable rest server and swagger
$SED_BINARY -i '0,/enable = false/s//enable = true/' $HOME_DIR/config/app.toml
$SED_BINARY -i 's/swagger = false/swagger = true/' $HOME_DIR/config/app.toml
$SED_BINARY -i -e 's/enabled-unsafe-cors = false/enabled-unsafe-cors = true/g' $HOME_DIR/config/app.toml
$SED_BINARY -i 's/minimum-gas-prices = "0.25uhype"/minimum-gas-prices = "0.0uhype"/' $HOME_DIR/config/app.toml
# Sign genesis transaction
$BINARY genesis gentx $KEY "1000000${DENOM}" --commission-rate=$COMMISSION_RATE --commission-max-rate=$COMMISSION_MAX_RATE --keyring-backend $KEYRING --chain-id $CHAIN_ID --home $HOME_DIR

# Collect genesis tx
$BINARY genesis collect-gentxs --home $HOME_DIR

# Run this to ensure everything worked and that the genesis file is setup correctly
$BINARY genesis validate-genesis --home $HOME_DIR
$BINARY start --home $HOME_DIR
