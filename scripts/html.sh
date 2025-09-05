#!/bin/bash

set -euo pipefail

errs=0
for cmd in envsubst pandoc minify ; do
    command -v "${cmd}" &>/dev/null || {
        echo "Cannot find ${cmd}." >&2
        errs=$(($errs+1))
    }
done

if [[ "${errs}" -gt 0 ]]; then
    echo "Quitting!"
    exit 1
fi


this_dir=$(readlink -qe "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )")
wd=$(readlink -qe "${this_dir}"/../)

cd "${wd}"

export BODY_HTML=$(
    pandoc --strip-comments --wrap none --filter pandoc-crossref --citeproc --bibliography literature.bibtex sota.md
)

envsubst < index.raw | minify --type html --html-keep-document-tags --html-keep-end-tags > index.html
