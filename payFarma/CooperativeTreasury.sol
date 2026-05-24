// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {FarmerRegistry} from "./FarmerRegistry.sol";
import {CoffeeDelivery} from "./CoffeeDelivery.sol";

contract CooperativeTreasury is FarmerRegistry,CoffeeDelivery{

    address public loanManager;
    uint256 public totalETHReceived;
    //eth that will be distributed
    uint256 public distributionPool;
    //eth saved for loans and repaiments
    uint256 public loanReserve;

    mapping(address => uint256) public pendingPayouts;
    uint256 constant public distributionPercent = 70;

    event ethRecieved(uint256 amount , address from);
    event payoutDistributed();
    event paidFarmer(address farmer, uint256 amount);
    event repaymentReceived(address indexed farmer, uint256 amount); 


    constructor(address _contractAddress ) FarmerRegistry() CoffeeDelivery(_contractAddress) {
        
    }

    modifier onlyLoanManager(){
        require(msg.sender == loanManager,"only loan contract can call this");
        _;

    }
    function setLoanManager(address _loanManager) external onlyOwner {
        require(loanManager == address(0), "Loan manager already set");
        require(_loanManager != address(0), "Invalid address");
        loanManager = _loanManager;
    }

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

        uint256 finalDistribution = (distributionPercent * msg.value ) / 100;

        distributionPool += finalDistribution;
        loanReserve += (msg.value - finalDistribution);

        distributeShares(finalDistribution);
        emit payoutDistributed();
    }

     function receiveRepayment() external payable onlyLoanManager {
        loanReserve += msg.value;
    }

    function withdraw() public {
        uint256 amount = pendingPayouts[msg.sender];
        require(amount > 0, "no pending amount:(");

        distributionPool -= amount;
        pendingPayouts[msg.sender] =0;


        (bool success,)= payable(msg.sender).call{value:amount }("");
        require(success, "payout failed!");

        emit paidFarmer(msg.sender, amount);


    }

    function getLoan(address farmer , uint256 amount) public onlyLoanManager {
        require(amount >0 , "invalid amount");
        require(amount <= loanReserve, "Insufficient funds in loan reserve"); 

        loanReserve -= amount;

        (bool success,)= payable(farmer).call{value:amount }("");
        require(success, "loan payout failed!");

    }

    
}