#!/bin/bash

# helpers
function usage() {
    echo "usage ${0##*/} <scriptfile> <passfile> <iplist>"
    echo "    <iplist> can be a file or varargs"
    exit 1
}

function missing_file() {
    echo "[${0##*/}] Missing $1 file $2"
    exit 2
}

function action() {
    echo ">>> --- Connect $3 [$4/$5]"
    sshpass -v -f $2 scp -o ConnectTimeout=5 \
            -o StrictHostKeyChecking=no $1 pyzeradmin@$3:~/
    sshpass -v -f $2 ssh -n -o ConnectTimeout=5 \
            -o StrictHostKeyChecking=no pyzeradmin@$3 \
            "chmod +x ${1##*/} ; ./${1##*/} ; rm ${1##*/}"
    echo "<<< --- Disconn $3"
}

function dry_action() {
    echo ">>> --- Connect $3 [$4/$5]"
    cat $1
    echo "<<< --- Disconn $3"
}

# sanity check
if [[ $# -lt 3 ]]; then
    usage
elif [ ! -f $1 ]; then
    missing_file "script" $1
elif [ ! -f $2 ]; then
    missing_file "pass" $2
fi

# mode check
ITERATOR_MODE=0 # 0 is list, 1 is file
IPV4_REGEX="^(([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))\.){3}([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))$"

if [[ $# -eq 3 ]]; then
    if [[ $3 =~ $IPV4_REGEX ]]; then
        ITERATOR_MODE=0
    elif [ ! -f $3 ]; then
        missing_file "device list" $3
    else
        ITERATOR_MODE=1
    fi
fi

# prettify
SCRIPT_FILE=$1
PASS_FILE=$2
COUNTER_CNT=0
COUNTER_MAX=0

# execute
echo "[${0##*/}] exec script ${SCRIPT_FILE} start at $(date)"
# file or argument list?
if [[ $ITERATOR_MODE -eq 1 ]]; then
    # file
    COUNTER_MAX=$(wc -l $3 | cut -f1 -d" ")
    echo "[${0##*/}] running in file mode"
    while read -r TARGET_IP; do
        ((COUNTER_CNT+=1))
        action $SCRIPT_FILE $PASS_FILE $TARGET_IP $COUNTER_CNT $COUNTER_MAX
    done < $3
else
    echo
    # argument list
    ARG_MAX=$#
    ((COUNTER_MAX=$ARG_MAX - 2))
    echo "[${0##*/}] running in argument list mode"
    for (( I=3; I<=$ARG_MAX; I+=1 ));
    do
        ((COUNTER_CNT+=1))
        TARGET_IP=${!I}
        action $SCRIPT_FILE $PASS_FILE $TARGET_IP $COUNTER_CNT $COUNTER_MAX
    done
fi

# finalize
echo "[${0##*/}] exec done at $(date)"
