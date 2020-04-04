#!/bin/sh
# using https://github.com/mlafeldt/tomdoc.sh
# Public: Current API version in format "x.y.z".
export API_VERSION="1.0.0"

# Public: Execute commands in debug mode.
#
# Takes a single argument and passes it in to script for paging to get the list of volume snapshots
#
# $1 - Page of results
#
# Examples
#
#   ./delete_volume_snapshots.sh "10"
#

function string_replace {
    echo "${1/\*/$2}"
}

curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $TF_VAR_digitalocean_token"  "https://api.digitalocean.com/v2/snapshots?page=$1" > temp.json 

cat temp.json

declare -a StringArray="$(cat temp.json | jq .snapshots[].id -r)" 
echo $StringArray
arr=($StringArray)

function cleanup {
    set -B                  # enable brace expansion
    for i in "${arr[@]}"
    do
        curl -X 'DELETE' -H 'Content-Type: application/json' -H 'Authorization: Bearer $TF_VAR_digitalocean_token' 'https://api.digitalocean.com/v2/snapshots/'$i
    done
}

cleanup