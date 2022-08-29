# smart-contracts

To build .mw file:

Install Aptos Commandline tool.

cargo install --git https://github.com/aptos-labs/aptos-core.git aptos --rev aptos-cli-v0.3.2

aptos move compile --package-dir . --named-addresses CasinoAddress=0x{casino_address_here}

Example: aptos move compile --package-dir . --named-addresses CasinoAddress=0x1234


# deploy
aptos move publish --profile alice  --named-addresses CasinoAddress={casino_address_here}

aptos move run --profile alice --function-id <casino_address_here>::Casino::initialize

```
example:
aptos move compile --package-dir . --named-addresses CasinoAddress=0xdf678d5fa266ace7d7ff38fd4c44ea407647a30ee8f1b6489ea90d5d0205d58f
aptos move publish --profile alice  --named-addresses CasinoAddress=0xdf678d5fa266ace7d7ff38fd4c44ea407647a30ee8f1b6489ea90d5d0205d58f
aptos move run --profile alice --function-id 0xdf678d5fa266ace7d7ff38fd4c44ea407647a30ee8f1b6489ea90d5d0205d58f::Casino::initialize

```