// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

struct Farmer{
        string name;
        address wallet;
        uint256 registrationDate;
        bool active;
    }

interface  IFarmerRegistry {
    function getFarmer(address _farmerAddress) external view returns(Farmer memory );    
}

contract MicroLoanManager{

    enum Status {
        pending,
        approved,
        rejected,
        repaid,
        defaulted
    }

    struct Loan {
        uint256 loanId;
        address farmer;
        uint256 requestedAmount;
        uint256 paidAmount;
        Status loanStatus;
    }
    
    address owner;
    IFarmerRegistry farmerRegis;
    mapping(address => uint256[]) public myLoans;
    Loan[] public allLoans;
    address public treasuryAddress;

    event loanRequested(address farmer, uint256 amount);
    event loanApproved(uint256 loanId);
    event loanRejected(uint256 loanId);
    event loanPaid(uint256 loanId);


    constructor(address _registryAddress){
        owner = msg.sender;
       farmerRegis = IFarmerRegistry(_registryAddress);

    }

    modifier onlyOwner{
        require(msg.sender ==owner, "only owner can do this");
        _;
    }

   function requestLoan(uint amount) public {
        Farmer memory checkedFarmer = farmerRegis.getFarmer(msg.sender);
        require(checkedFarmer.active, "Farmer is not active or registered"); 
        require(amount >0 ,"invalid amount");
        
        Loan memory l1 = Loan(allLoans.length + 1,msg.sender , amount ,0 ,Status.pending);
        myLoans[msg.sender].push(allLoans.length +1 );
        allLoans.push(l1);

        emit loanRequested(msg.sender, amount);

   }

   function approveLoan(address farmer, uint256 _loanId) public onlyOwner{
       require(_loanId > allLoans.length,"loan index out ofbound");
       require(myLoans[farmer].length >0,"farmer has no registered loans");

        Loan storage checkLoan = allLoans[_loanId - 1];
        checkLoan.loanStatus= Status.approved;

        emit loanApproved(_loanId);
        
   }
}