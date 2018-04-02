# private-sale-contract
This is the private sale contact which will be used for IAME's private sale. Special thanks to @jevdiego for his contribution

### Prerequisites

:floppy_disk: Install Truffle and Ganache

:mushroom: Truffle:
npm install -g truffle

:cake:Ganache:
https://github.com/trufflesuite/ganache/releases

### Using the project

Ensure the truffle-config.js file is updated if you are using windows and truffle.js if you are using mac os to use the configuration of the
networks you would like to deploy/migrate to

:computer: Compiling:
truffle compile

:runner: Migrate/Deploy
truffle migrate --network ganache

:zap: Test the contract
truffle test ./test/iame_presale.js

**NOTE**: Use 'truffle.cmd' instead of 'truffle' on Windows. E.G. 'truffle.cmd compile'

