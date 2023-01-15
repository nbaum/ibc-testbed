N=${N-N}

export N
export CHAIN=chain$N
export ADDRESS=127.0.1.$N
export NODENAME=node$N
export CUDOS_HOME=var/run/$CHAIN
export CUDOS_NODE=http://127.0.1.$N:26657
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
  cudos-noded keys show $1 -a --keyring-backend test
}

make-account() {
  NAME=$1
  shift
  echo "$*" | cudos-noded keys add $NAME --keyring-backend test --recover --output json >/dev/null 2>&1
  cudos-noded add-genesis-account $(address $NAME) 1$ECUDOS >/dev/null
}

query() {
  cudos-noded query "$@" --node=$CUDOS_NODE --chain-id=$CHAIN
}

tx() {
  if ! [[ -z $SENDER ]]; then
    cudos-noded tx "$@" --from $SENDER --keyring-backend=test --node=$CUDOS_NODE --chain-id=$CHAIN --gas auto --gas-prices=0acudos -y
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
  if ! [[ -z $PORT || -z $CHANNEL || -t $TO || -t $AMOUNT ]]; then
    tx ibc-transfer transfer "$PORT" "$CHANNEL" "$TO" "$AMOUNT" >/dev/null
  else
    echo usage: ibc-transfer PORT CHANNEL TO AMOUNT > /dev/stderr
    false
  fi
}

wasm-store() {
  local NAME=$1
  local FILE=$2
  if ! [[ -z $FILE || -z $NAME ]]; then
    mkdir -p $CUDOS_HOME/codes
    tx wasm store "$FILE" --note "$NAME" | \
      jq -r '.logs[].events[].attributes[]|select(.key=="code_id").value' | \
      sponge "$CUDOS_HOME/codes/$NAME"
    echo stored: code $(cat $CUDOS_HOME/codes/$NAME) noted in "$CUDOS_HOME/codes/$NAME"
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
    mkdir -p $CUDOS_HOME/instances
    CODE=$(cat $CUDOS_HOME/codes/$CODE)
    tx wasm instantiate "$CODE" "$(cat $INIT | yq -j | jq -r tostring)" --label $NAME --admin $(address $SENDER) | \
      jq -r '.logs[].events[].attributes[]|select(.key=="_contract_address").value' | \
      sponge "$CUDOS_HOME/instances/$NAME"
    echo instantiated: instance $(cat $CUDOS_HOME/instances/$NAME) noted in "$CUDOS_HOME/instances/$NAME"
  else
    echo usage: wasm-instantiate NAME CODE INIT > /dev/stderr
    false
  fi
}
