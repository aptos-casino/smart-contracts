# smart-contracts

To build .mw file:

Install Aptos Commandline tool.

cargo install --git https://github.com/aptos-labs/aptos-core.git aptos --rev aptos-cli-v0.2.6

aptos move compile --package-dir . --named-addresses CasinoAddress=0x{casino_address_here}

Example: aptos move compile --package-dir . --named-addresses CasinoAddress=0x1234


# deploy
aptos move publish --profile alice  --named-addresses CasinoAddress={casino_address_here}

aptos move run --profile alice --function-id <casino_address_here>::Casino::initialize

```
example:
aptos move compile --package-dir . --named-addresses CasinoAddress=0x824ed657a560a964007d34f4be97ac19e111a3b2d24a03b105a9f265d41e813b
aptos move publish --profile alice  --named-addresses CasinoAddress=0x824ed657a560a964007d34f4be97ac19e111a3b2d24a03b105a9f265d41e813b
aptos move run --profile alice --function-id 0x824ed657a560a964007d34f4be97ac19e111a3b2d24a03b105a9f265d41e813b::Casino::initialize

```