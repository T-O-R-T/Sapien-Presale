pragma solidity ^0.4.18;

import "contracts/Owned.sol";
import "contracts/interfaces/DynamicCrowdsaleInterface.sol";

contract DynamicCrowdsale is DynamicCrowdsaleInterface {

    /// @dev `owner` is the only address that can call a function with this
    /// modifier
    modifier onlyOwner() {
        require(msg.sender == owned.getOwner());
        _;
    }

    Owned private owned;

    function DynamicCrowdsale(address _owned) {

        owned = Owned(_owned);

    }

    function() payable {

        revert();

    }

    function addMilestone(uint256 block, uint256 investment) public onlyOwner {

        require(stages[maxPosition].blockNumber < block);
        require(stages[maxPosition].permittedInvestment > investment);

        var stage = Stage(block, investment);

        stages.push(stage);

        maxPosition += 1;

    }

    function deleteMilestone(uint256 position) public onlyOwner {

        delete stages[position];

        for (uint i = position; i < maxPosition - 1; i++) {

            stages[i] = stages[i + 1];

        }

        maxPosition -= 1;

    }

    function allowedInvestment(uint256 totalWei) public returns (uint256) {

        if (totalWei > stages[position].permittedInvestment) {

            return stages[position].permittedInvestment;

        } else {

            return totalWei;

        }
            
    }

    function getCurrentStage() public returns (uint256) {

        return position;

    }

    function setCurrentStage(uint256 stage) public onlyOwner {

        position = stage;

    }

    function getCurrentMaxInvestment() public returns (uint256) {

        return stages[position].permittedInvestment;

    }

}