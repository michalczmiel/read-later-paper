#!/usr/bin/env bash

set -e

OUTPUT="read-later.pdf"

function html_tempfile() {
  echo $(mktemp $TMPDIR/$(uuidgen).html)
}

function prepare_page() {
  echo '<link rel="stylesheet" href="https://unpkg.com/gutenberg-css@0.6">' >>$1
  echo '<link rel="stylesheet" href="https://unpkg.com/gutenberg-css@0.6/dist/themes/modern.min.css">' >>$1
}

function main() {
  files=()

  for url in "$@"; do
    tfile=$(html_tempfile)

    curl $url --output $tfile

    prepare_page $tfile

    files+=($tfile)
  done

  wkhtmltopdf "${files[@]}" $OUTPUT
}

if [ $# -eq 0 ]; then
    echo "No urls provided"
    exit 1
fi

main "$@"
