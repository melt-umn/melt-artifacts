#!/usr/bin/env bash
set -euxo pipefail

cd "$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
test ! -d nanopass-ag || rm -rf nanopass-ag
git clone git@github.umn.edu:ringo025/nanopass-ag.git
cp example.nag nanopass-ag/compiler/src/example.nag
docker build -t melt-umn/nanopass-ags .
