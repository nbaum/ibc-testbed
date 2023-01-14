
if [ "$N" == "" ]; then
  echo $0: N is not set to chain number
  exit 1
fi

export N
export CHAIN=chain$N
export ADDRESS=127.0.1.$N
export NODENAME=node$N
export CUDOS_HOME=var/run/$CHAIN
export ACUDOS=acudos
export FCUDOS=000$ACUDOS
export PCUDOS=000$FCUDOS
export NCUDOS=000$PCUDOS
export UCUDOS=000$NCUDOS
export MCUDOS=000$UCUDOS
export CUDOS=000$MCUDOS
export kCUDOS=000$CUDOS
export MCUDOS=000$kCUDOS
export GCUDOS=000$MCUDOS
export TCUDOS=000$GCUDOS
export PCUDOS=000$PCUDOS

use-chain() {
  if [ "$1" == "" ]; then
    echo Usage: use-chain N
    return
  fi
  export N=$1
  source include/variables.sh
}

address() {
  cudos-noded keys show $1 -a --keyring-backend test
}

tx() {(
  # set -o xtrace -e
  if ! [[ -z $SENDER ]]; then
    cudos-noded tx "$@" --from $SENDER --keyring-backend=test --node=$CUDOS_NODE --chain-id=$CUDOS_CHAIN_ID --gas auto -y
  else
    echo usage: SENDER=... tx COMMAND... > /dev/stderr
    false
  fi
)}

ibc-transfer() {
  local PORT=$1
  local CHANNEL=$2
  local TO=$3
  local AMOUNT=$4
  if ! [[ -z $PORT || -z $CHANNEL || -t $TO || -t $AMOUNT ]]; then
    tx ibc-transfer transfer "$PORT" "$CHANNEL" "$TO" "$AMOUNT" 2>&1 >/dev/null
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
    tx wasm instantiate "$CODE" "$(cat $INIT | yq -j | jq -r tostring)" --label $NAME --admin $(account-address $SENDER) | \
      jq -r '.logs[].events[].attributes[]|select(.key=="_contract_address").value' | \
      sponge "$CUDOS_HOME/instances/$NAME"
    echo instantiated: instance $(cat $CUDOS_HOME/instances/$NAME) noted in "$CUDOS_HOME/instances/$NAME"
  else
    echo usage: wasm-instantiate NAME CODE INIT > /dev/stderr
    false
  fi
}
