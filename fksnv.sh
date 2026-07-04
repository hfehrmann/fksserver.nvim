#!/usr/bin/env zsh

usage() {
    echo "Open and focus files in the nvim instance that is running the fks server"
    echo ""
    echo "Usage: fkns [-o] file [...]"
    echo "Options:"
    echo "  -o    Only open the file, no focus."
    exit 0
}

FOCUS=":FKSFocusMe<CR>"

while getopts "oh" opt; do
    case $opt in
        o)
            FOCUS=""
            ;;
        h)
            usage
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

if [ "${#OPEN_FILES[@]}" -eq 0 ]; then
    exit 1
fi

JOINED_OPEN_FILES=$(IFS="" && echo "${OPEN_FILES[*]}")

SOCKET="/tmp/fks_nvim_server.sock"
if [[ ! -e $SOCKET ]]; then
    echo "fksnv: There is no fks server running. Please start one" >&2
    exit 1
fi

COMMAND="<C-\\><C-N>${FOCUS}${JOINED_OPEN_FILES}"

nvim --headless --server $SOCKET --remote-send $COMMAND

