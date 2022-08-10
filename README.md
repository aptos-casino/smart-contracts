# smart-contracts

To build .mw file:

Install Aptos Commandline tool.

cargo install --git https://github.com/aptos-labs/aptos-core.git aptos --tag aptos-cli-v0.2.3

aptos move compile --package-dir . --named-addresses CasinoAddress=0x{casino_address_here}

Exemple: aptos move compile --package-dir . --named-addresses CasinoAddress=0x1234