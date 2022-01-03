import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/TokenTimelockUpgradeable.sol";
contract timelock is TokenTimelockUpgradeable {
    function initialize(address contractAddress, address beneficiary, uint256 releaseTime) public initializer{
        __TokenTimelock_init(ERC20Upgradeable(contractAddress), beneficiary, releaseTime);
    }
}