# Create a folder and move into it in one command
function mkcd() { mkdir -p "$@" && cd "$_"; }
