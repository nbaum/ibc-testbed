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