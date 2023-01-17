# IBC testbed

## Preparation

You'll need either `wasmd` or `cudos-noded` installed.

* https://github.com/CosmWasm/wasmd
* https://github.com/CudoVentures/cudos-node

You'll need to install supervisor.

* http://supervisord.org/

You'll need to install ts-relayer.

* https://github.com/confio/ts-relayer

To use other node binaries, you'll need to do some editing.

Edit etc/env to select which node binary you'll be using.

## Using

It probably won't work properly unless you're in the root directory of the repo.

## Starting from scratch

Run `bin/init`.

This wipes out any existing chain data.

## Stopping

Run `bin/stop`.

## Starting again

Run `bin/start`.

## Cleaning up

Run `bin/destroy`.

## Other commands

Some commands require `source include/env.sh` first.

### use-chain

`use-chain N`

### address

`address ACCOUNT_NAME`

### make-account

`make-account NAME MNEMONIC...`

### ibc-transfer

`ibc-transfer PORT CHANNEL RECIPIENT AMOUNT`

### wasm-store

`wasm-store NAME WASM_FILE`

### cw20-create

`cw20-create TOKEN NAME DECIMALS AMOUNT`

Creates a new CW20 token from the cw20_base contract, which must have been stored using
`wasm-store`.

AMOUNT tokens are given to `account0`.

Operates on the current chain.

e.g.

cw20-create COIN 'CoinCoin' 2 1000000

### cw20-balance

`cw20-balance TOKEN [ADDRESS]`

Shows the balance of the token for the address, or account0 if the address is not given.

Operates on the current chain.

### cw20-info

`cw20-info TOKEN`

### cw20-send

`cw20-info TOKEN RECIPIENT AMOUNT`

### cw20-ics20-create

`cw20-ics20-create BRIDGE`

Creates a CW20-ICS20 bridge. Note it isn't connected to anything.

### cw20-ics20-send

`cw20-ics20-send BRIDGE TOKEN AMOUNT CHANNEL RECIPIENT`
