pragma solidity ^0.8.10;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

contract NaruToken is Initializable, ERC20Upgradeable, UUPSUpgradeable,OwnableUpgradeable {
    function initialize(uint256 mintAmount) public initializer{
        __ERC20_init("Naru Token", "$NARU"); 
        __Ownable_init();
        _mint(msg.sender, mintAmount);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    

   
}
