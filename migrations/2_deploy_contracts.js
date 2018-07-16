var Lotto = artifacts.require("Lotto");
var LottoTokenSale = artifacts.require("LottoTokenSale");

module.exports = function(deployer) {
    deployer.deploy(Lotto).then(function(){
        deployer.deploy(LottoTokenSale, Lotto.address);
    });
};