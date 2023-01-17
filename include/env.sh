N=${N-N}

ROOT=$(readlink -f $PWD/${BASH_SOURCE%/*}/..)
export N
export CHAIN=chain$N
export ADDRESS_PREFIX=169.254.1
export ADDRESS_PREFIX=127.0.1
export ADDRESS_PREFIX=192.168.2
export ADDRESS=$ADDRESS_PREFIX.$N
export NODENAME=node$N
export NODE_HOME=$ROOT/var/run/$CHAIN
export RELAYER_HOME=$ROOT/var/run/relayer
export CUDOS_NODE=http://$ADDRESS:26657
export aCUDOS=acudos
export fCUDOS=000$aCUDOS
export pCUDOS=000$fCUDOS
export nCUDOS=000$pCUDOS
export uCUDOS=000$nCUDOS
export mCUDOS=000$uCUDOS
export CUDOS=000$mCUDOS
export kCUDOS=000$CUDOS
export MCUDOS=000$kCUDOS
export GCUDOS=000$MCUDOS
export TCUDOS=000$GCUDOS
export PCUDOS=000$TCUDOS
export ECUDOS=000$PCUDOS
export ZCUDOS=000$ECUDOS
export YCUDOS=000$ZCUDOS
export RCUDOS=000$YCUDOS
export QCUDOS=000$RCUDOS
export SENDER=account0
export NODED=cudos-noded
# export NODED=wasmd

if [[ $NODED == cudos-noded ]]; then
  export PREFIX=cudos
else
  export PREFIX=wasm
fi

use-chain() {
  if [ "$1" == "" ]; then
    echo Usage: use-chain N
    return
  fi
  export N=$1
  source include/env.sh
  ROOT=$(readlink -f $PWD/${BASH_SOURCE%/*}/..)
  PATH=$ROOT/bin:$ROOT/lib:$PATH
  echo configured $CHAIN
}

address() {
  $NODED keys show $1 -a --keyring-backend test --home $NODE_HOME
}

make-account() {
  set -o xtrace
  NAME=$1
  shift
  echo "$*" | $NODED keys add $NAME --home $NODE_HOME --keyring-backend test --recover --output json >/dev/null
  $NODED add-genesis-account $(address $NAME) 1$ECUDOS --home $NODE_HOME >/dev/null
}

query() {
  $NODED query "$@" --node=$CUDOS_NODE --chain-id=$CHAIN
}

tx() {
  if ! [[ -z $SENDER ]]; then
    $NODED tx "$@" --from $SENDER --home $NODE_HOME --keyring-backend=test --node=$CUDOS_NODE --chain-id=$CHAIN --gas auto --gas-adjustment 1.3 --gas-prices=0acudos --output json -b block -y
  else
    echo usage: SENDER=... tx COMMAND... > /dev/stderr
    false
  fi
}

ibc-transfer() {
  local PORT=$1
  local CHANNEL=$2
  local TO=$3
  local AMOUNT=$4
  if ! [[ -z $PORT || -z $CHANNEL || -z $TO || -z $AMOUNT ]]; then
    tx ibc-transfer transfer "$PORT" "$CHANNEL" "$TO" "$AMOUNT"acudos >/dev/null
  else
    echo usage: ibc-transfer PORT CHANNEL TO AMOUNT > /dev/stderr
    false
  fi
}

wasm-store() {
  local NAME=$1
  local FILE=$2
  if ! [[ -z $FILE || -z $NAME ]]; then
    mkdir -p $NODE_HOME/codes
    RESULT=$(tx wasm store "$FILE" --note "$NAME")
    echo "$RESULT"
    echo "$RESULT" | \
      jq -r '.logs[].events[].attributes[]|select(.key=="code_id").value' | \
      sponge "$NODE_HOME/codes/$NAME"
    echo stored: code $(cat $NODE_HOME/codes/$NAME) noted in "$NODE_HOME/codes/$NAME"
  else
    echo usage: wasm-store NAME FILE > /dev/stderr
    false
  fi
}

wasm-instantiate() {
  local NAME=$1
  local CODE=$2
  local INIT=$3
  if ! [[ -z $NAME || -z $CODE || -z $INIT ]]; then
    mkdir -p $NODE_HOME/instances
    CODE=$(cat $NODE_HOME/codes/$CODE)
    tx wasm instantiate "$CODE" "$(cat $INIT | yq -j | jq -r tostring)" --label $NAME --admin $(address $SENDER) | \
      jq -r '.logs[].events[].attributes[]|select(.key=="_contract_address").value' | \
      sponge "$NODE_HOME/instances/$NAME"
    echo instantiated: instance $(cat $NODE_HOME/instances/$NAME) noted in "$NODE_HOME/instances/$NAME"
  else
    echo usage: wasm-instantiate NAME CODE INIT > /dev/stderr
    false
  fi
}
