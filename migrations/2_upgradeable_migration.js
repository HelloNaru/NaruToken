const { deployProxy, upgradeProxy } = require('@openzeppelin/truffle-upgrades');
const NaruToken = artifacts.require("NaruToken");

module.exports = async function (deployer) {
    const instance = await deployProxy(NaruToken, {kind:'uups'});
    console.log("contract address:"+instance.address);
}