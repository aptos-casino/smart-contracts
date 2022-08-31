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
export CasinoAddress=e091e84b7945603712d7791d550bba99121622a204d85ea2bcda8ec70f485545
aptos move compile --package-dir . --named-addresses CasinoAddress=$CasinoAddress
aptos move publish --profile alice  --named-addresses CasinoAddress=$CasinoAddress
aptos move run --profile alice --function-id $CasinoAddress::Casino::initialize
```