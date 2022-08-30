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
export CasinoAddress=fd1bfbe6be0108028a219543d29b27b76137fe037de9d53df0c78f9266b92be8
aptos move compile --package-dir . --named-addresses CasinoAddress=$CasinoAddress
aptos move publish --profile alice  --named-addresses CasinoAddress=$CasinoAddress
aptos move run --profile alice --function-id $CasinoAddress::Casino::initialize
```