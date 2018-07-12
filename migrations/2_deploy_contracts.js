var LottoToken = artifacts.require("LottoToken");
var LottoTokenSale = artifacts.require("LottoTokenSale");

module.exports = function(deployer) {
    deployer.deploy(LottoToken).then(function(){
        deployer.deploy(LottoTokenSale, LottoToken.address);
    });
};