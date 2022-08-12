# smart-contracts

To build .mw file:

Install Aptos Commandline tool.

cargo install --git https://github.com/aptos-labs/aptos-core.git aptos --rev aptos-cli-v0.2.3

aptos move compile --package-dir . --named-addresses CasinoAddress=0x{casino_address_here}

Example: aptos move compile --package-dir . --named-addresses CasinoAddress=0x1234


# deploy
aptos move publish --profile alice  --named-addresses CasinoAddress={casino_address_here}

aptos move run --profile alice --function-id <casino_address_here>::Casino::initialize --args address:<casino_address_here>

