#!/usr/bin/env bash

VERSION="0.1.0"

usage() {
    echo "Open and focus files in the nvim instance that is running the fks server"
    echo ""
    echo "Usage: fksnv [-o] file [...]"
    echo "Options:"
    echo "  -h    Show this help."
    echo "  -o    Only open the files, no focus."
    echo "  -s    Change the nvim socket to send the commands (default: fks_nvim_server)."
    echo "  -v    Shows the version."
    exit 0
}

version() {
    echo "Fokus nvim server (fksnv) $VERSION"
    exit 0
}

FOCUS=":FKSFocusMe<CR>"
SOCKET_NAME="fks_nvim_server"

while getopts "hos:v" opt; do
    case $opt in
        h)
            usage
            ;;
        o)
            FOCUS=""
            ;;
        s)
            SOCKET_NAME="$OPTARG"
            ;;
        v)
            version
            ;;
    esac
done

shift $((OPTIND - 1))

OPEN_FILES=()

for ARG in "$@" ; do
    FILE=""
    if [[ "$ARG" = /* ]]; then
        FILE="$ARG"
    else
        FILE="$(pwd)/$ARG"
    fi

    if [[ ! -e $FILE ]]; then
        echo "fksnv: $ARG: No such file or directory" >&2
        continue
    fi

    OPEN_FILES+=(":FKSOpen $FILE<CR>")
done

if [ "${#OPEN_FILES[@]}" -eq 0 -a -z "$FOCUS" ]; then
    echo "fksnv: No focus and no files given" >&2
    exit 1
fi

JOINED_OPEN_FILES=$(IFS="" && echo "${OPEN_FILES[*]}")

SOCKET="/tmp/$SOCKET_NAME.sock"
if [[ ! -e $SOCKET ]]; then
    echo "fksnv: There is no fks server running. Please start one" >&2
    exit 1
fi

COMMAND="<C-\\><C-N>${FOCUS}${JOINED_OPEN_FILES}"

nvim --headless --server "$SOCKET" --remote-send "$COMMAND"

