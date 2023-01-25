#!/usr/bin/env bash
# exit on error
set -o errexit
# Initial setup
npm i --prefix assets
npm run build --prefix assets
mix deps.get --only prod
MIX_ENV=prod mix compile
MIX_ENV=prod mix assets.deploy