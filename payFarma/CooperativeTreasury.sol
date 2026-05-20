// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {FarmerRegistry} from "./FarmerRegistry.sol";
import {CoffeeDelivery} from "./CoffeeDelivery.sol";

contract CooperativeTreasury is FarmerRegistry,CoffeeDelivery{

    uint256 public totalETHReceived;
    mapping(address => uint256) public pendingPayouts;

    event ethRecieved(uint256 amount , address from);


    function distributeShares() internal {

    }

    receive() external payable{
        emit ethRecieved(msg.value, msg.sender);
        totalETHReceived += msg.value;
    }
}