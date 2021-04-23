var CoinContract = artifacts.require('CoinContract');

module.exports = function(deployer) {
    deployer.deploy(CoinContract);
    // Additional contracts can be deployed here
};
