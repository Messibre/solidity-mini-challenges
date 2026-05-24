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

interface ICooperativeTreasury {
       function getLoan(address farmer , uint256 amount) external;
        function receiveRepayment() external payable; 
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
    
    address public owner;
    IFarmerRegistry public farmerRegis;
    ICooperativeTreasury public treasury;

    mapping(address => uint256[]) public myLoans;
    Loan[] public allLoans;

    address public treasuryAddress;

    event loanRequested(address farmer, uint256 amount);
    event loanApproved(uint256 loanId);
    event loanRejected(uint256 loanId);
    event loanPaid(uint256 loanId , uint256 amount);


   

    modifier onlyOwner{
        require(msg.sender ==owner, "only owner can do this");
        _;
    }

     constructor(address _registryAndtreasuryAddress){
        owner = msg.sender;
       farmerRegis = IFarmerRegistry(_registryAndtreasuryAddress);
       treasury = ICooperativeTreasury(_registryAndtreasuryAddress);

    }

   function requestLoan(uint amount) public {
        Farmer memory checkedFarmer = farmerRegis.getFarmer(msg.sender);
        require(checkedFarmer.active, "Farmer is not active or registered"); 
        require(amount >0 ,"invalid amount");
        
        uint256 newLoanId = allLoans.length + 1;
        Loan memory l1 = Loan(newLoanId, msg.sender, amount, 0, Status.pending);

        myLoans[msg.sender].push(newLoanId);
        allLoans.push(l1);

        emit loanRequested(msg.sender, amount);

   }

   function approveLoan(address farmer, uint256 _loanId) public onlyOwner{
       require(_loanId > 0 && _loanId <= allLoans.length,"loan index out ofbound");
       require(myLoans[farmer].length >0,"farmer has no registered loans");

        Loan storage checkLoan = allLoans[_loanId - 1];
        require(checkLoan.loanStatus == Status.pending, "Loan not pending");

        checkLoan.loanStatus= Status.approved;

        treasury.getLoan(farmer, checkLoan.requestedAmount);
        emit loanApproved(_loanId);
        
   }

   function repayLoan(uint256 _loanId) public payable{
        require(_loanId > 0 && _loanId <= allLoans.length,"loan index out ofbound");

        Loan storage checkLoan = allLoans[_loanId - 1];
        require(checkLoan.farmer == msg.sender, "Not your loan to repay");
        require(checkLoan.loanStatus == Status.approved, "Loan not pending");
        require(msg.value > 0, "Must send ETH to repay");

        checkLoan.paidAmount += msg.value;

         if (checkLoan.paidAmount >= checkLoan.requestedAmount) {
            checkLoan.loanStatus = Status.repaid;
        }

        treasury.receiveRepayment{value: msg.value}();

        emit loanPaid(_loanId, msg.value);

   }
}