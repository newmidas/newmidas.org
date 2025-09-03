#!/bin/bash

# Kudos: https://recursewithless.net/projects/pandoc-feeds.html
# Decisions about file names kudos: https://blog.jim-nielsen.com/2021/feed-urls/
# Definitive RSS location:  /feed.xml
# Definitive Atom location: /feed.atom

set -euo pipefail

this_dir=$(readlink -qe "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )")
wd=$(readlink -qe "${this_dir}"/../)

cd "${wd}"

f="feed.xml"

# Remember, date must be in RFC822 format.

pandoc \
    -M updated="$(date '+%a, %d %b %Y %H:%M:%S %Z')" \
    -M title='New MIDAS' \
    --metadata-file=templates/feed.yaml \
    --template=templates/rss.xml \
    --wrap=none \
    -t html \
    < /dev/null \
    | tidy -w -q -i -xml > "${f}"
