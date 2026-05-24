// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {FarmerRegistry} from "./FarmerRegistry.sol";
import {CoffeeDelivery} from "./CoffeeDelivery.sol";

contract CooperativeTreasury is FarmerRegistry,CoffeeDelivery{

    uint256 public totalETHReceived;
    mapping(address => uint256) public pendingPayouts;

    event ethRecieved(uint256 amount , address from);
    event payoutDistributed();
    event paidFarmer(address farmer, uint256 amount);

    constructor(address _contractAddress) FarmerRegistry() CoffeeDelivery(_contractAddress) {}


    function distributeShares(uint256 amountToBeDistributed) internal {
        uint256 totalUnpaid;

        //to get total unpaid weight
        for(uint256 i=0;i<farmers.length;i++){
           (,uint256 totalUnpaidDelivered )= getTotalDelivered(farmers[i]);
           totalUnpaid += totalUnpaidDelivered;
        }

        require(totalUnpaid > 0, "No unpaid deliveries");
        //to calculate each farmers share
        for(uint256 i=0;i<farmers.length;i++){
          (,  uint256 unpaid) = getTotalDelivered(farmers[i]);
          uint256 balance = unpaid* amountToBeDistributed / totalUnpaid ;
          pendingPayouts[farmers[i]]+=balance;
        }
    }

    receive() external payable{
        emit ethRecieved(msg.value, msg.sender);
        totalETHReceived += msg.value;
        distributeShares(msg.value);
        emit payoutDistributed();


    }

    function withdraw() public {
        require(pendingPayouts[msg.sender] > 0, "no pending amount:(");
        (bool success,)= payable(msg.sender).call{value:pendingPayouts[msg.sender] }("");
        require(success, "payout failed!");
        emit paidFarmer(msg.sender, pendingPayouts[msg.sender]);
        pendingPayouts[msg.sender] =0;


    }
}