#!/bin/bash
rm -r out
mkdir out
elm make src/Main.elm --output=out/app.js --optimize
elm make src/Main2.elm --output=out/app2.js --optimize

cp ./index.html out
cp ./index2.html out