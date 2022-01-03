pragma solidity ^0.8.10;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./StakableBase.sol";

contract NaruToken is Initializable, ERC20Upgradeable, UUPSUpgradeable,OwnableUpgradeable,StakableBase {
    function initialize(uint256 mintAmount) public initializer{
        __ERC20_init("Naru Token", "$NARU"); 
        __Ownable_init();
        _mint(msg.sender, mintAmount);
        _init_stakable(1000); //stands for 0.001%
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function stake(uint256 _amount) public {
        require(_amount < balanceOf(msg.sender),"Naru Token: Cannot stake more than you own");
        _stake(_amount);
        _burn(msg.sender,_amount);
    }

    function withdrawStake(uint256 amount, uint256 stake_index) public {
        uint256 amount_to_mint = _withdrawStake(amount, stake_index);
        _mint(msg.sender, amount_to_mint);
    }

   
}