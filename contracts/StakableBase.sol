// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract StakableBase is Initializable{


    //represent the way to store stakes
    struct Stake{
        address user;
        uint256 amount;
        uint256 since;
        uint256 claimable;
    }
    //staker with active stakes
    struct Stakeholder {
        address user;
        Stake[] address_stakes;
    }

    //StakingSummary is a struct that is used to contain all stakes performed by a certain account
    struct StakingSummary{
        uint256 total_amount;
        Stake[] stakes;
    }

    //array where all stakes are stored
    Stakeholder[] internal stakeholders;
    
    //used to keep track of the INDEX for the stakers in the stakes array
    mapping(address=>uint256) internal stakes;

    event Staked(address indexed user, uint256 amount, uint256 index, uint256 timestamp);

    uint256 internal _rewardPerHour;

    function _init_stakable(uint rewardPerHour_) internal onlyInitializing {
        _rewardPerHour = rewardPerHour_;
    }

    //_addStakeholder takes care of adding a stakeholder to the stakeholders array
    function _addStakeholder(address staker) internal returns (uint256) {
        stakeholders.push();
        uint256 userIndex = stakeholders.length-1;
        stakeholders[userIndex].user = staker;
        stakes[staker] = userIndex;
        return userIndex;
    }

    //_stake is used to make a stake for a sender, 
    //It'll remove the amount staked from the stakers account and place those tokens inside a stake container
    function _stake(uint256 _amount) internal {
        require(_amount > 0, "Cannot stake nothing");
        uint256 index = stakes[msg.sender];
        uint256 timestamp = block.timestamp;
        if(index==0){
            index = _addStakeholder(msg.sender);
        }

        stakeholders[index].address_stakes.push(
            Stake(msg.sender,_amount,timestamp,0)
        );

        emit Staked(msg.sender, _amount, index, timestamp);
    }

    function calculateStakeReward(Stake memory _current_stake) internal view returns(uint256){
        return (((block.timestamp - _current_stake.since) / 1 hours) * _current_stake.amount) / _rewardPerHour;
    }

    function _withdrawStake(uint256 amount, uint256 index) internal returns(uint256){
        uint256 user_index = stakes[msg.sender];
        Stake memory current_stake = stakeholders[user_index].address_stakes[index];
        require(current_stake.amount >= amount, "Staking: cannot withdraw more than you have staked");
        uint256 reward = calculateStakeReward(current_stake);
        current_stake.amount = current_stake.amount - amount;
        if (current_stake.amount ==0){
            delete stakeholders[user_index].address_stakes[index];
        }else{
            stakeholders[user_index].address_stakes[index].amount = current_stake.amount;
            stakeholders[user_index].address_stakes[index].since = block.timestamp;
        }

        return amount+reward;
    }

    //hasStake is used to check if an account has stakes and the total amount along with all the seperate stakes
    function hasStake(address _staker) public view returns(StakingSummary memory){
        uint256 totalStakeAmount;
        StakingSummary memory summary = StakingSummary(0, stakeholders[stakes[_staker]].address_stakes);
        for (uint256 s = 0; s<summary.stakes.length; s += 1){
            uint256 availableReward = calculateStakeReward(summary.stakes[s]);
            summary.stakes[s].claimable = availableReward;
            totalStakeAmount = totalStakeAmount + summary.stakes[s].amount;
        }

        summary.total_amount = totalStakeAmount;
        return summary;
    }

    //hasStake function includes all the information

    // function totalLengthOfStake() public view returns(uint256) {
    //     uint256 user_index = stakes[msg.sender];
    //     return stakeholders[user_index].address_stakes.length;
    // }

    // function stakeOfIndex(uint256 index) public view returns(uint256) {
    //     uint256 user_index = stakes[msg.sender];
    //     Stake memory current_stake = stakeholders[user_index].address_stakes[index];
    //     return current_stake.amount;
    // }

    // function rewardOfIndex(uint256 index) public view returns(uint256) {
    //     uint256 user_index = stakes[msg.sender];
    //     Stake memory current_stake = stakeholders[user_index].address_stakes[index];
    //     return calculateStakeReward(current_stake);
    // }

}