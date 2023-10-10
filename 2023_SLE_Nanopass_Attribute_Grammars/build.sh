#!/usr/bin/env bash
set -euxo pipefail

cd "$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
test ! -d nanopass-ag || rm -rf nanopass-ag
git clone git@github.umn.edu:ringo025/nanopass-ag.git
cp example.nag nanopass-ag/compiler/src/example.nag
docker build -t melt-umn/nanopass-ags .
docker save melt-umn/nanopass-ags > 2023_SLE_Nanopass_Attribute_Grammars.docker
files=(
	2023_SLE_Nanopass_Attribute_Grammars.docker
	Abstract.txt
	Getting-Started.txt
	paper.pdf
)
tar czf 2023_SLE_Nanopass_Attribute_Grammars.tar.gz "${files[@]}"
zip 2023_SLE_Nanopass_Attribute_Grammars.zip "${files[@]}"
