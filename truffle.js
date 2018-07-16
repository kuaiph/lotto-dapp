// Allows us to use ES6 in our migrations and tests.
require('babel-register')

var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "sister brush mass poet style join banana bring dignity feel ring grab";
var address = "0xE6e5ab45bB18fbaCA334A747Df40F8F41E6a1Fd8";
var infura_apikey = "M67G281JXASNBDZG2NKHATAZX7XKS44RA5";

module.exports = {
    networks: {
        development: {
            host: "127.0.0.1", // http://localhost:7545
            port: 8545,
            network_id: "*" // Match any network id
        },
        testnet: {
            provider: function() {
                return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/"+ infura_apikey, 0);
            },
            network_id: 3,
            gas: 4000000
        }
    }
};
