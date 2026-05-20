// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

error farmerNotFound(string msg);
error alreadyRegistered(string msg);

contract FarmerRegistry{

    struct Farmer{
        string name;
        address wallet;
        uint256 registrationDate;
        bool active;
    }
    address public owner;
    mapping(address=>Farmer) farmer;
    mapping(address=>uint256) farmerId;
    address[] public registeredFarmers;

    event FarmerRegistered(string name, address wallet);
    event FarmerDeactivated(address wallet);

    constructor(){
        owner=msg.sender;
    }
    modifier onlyOwner {
        require(msg.sender==owner,"only owner can do this");
        _;
    }

    function registerFarmer(string calldata _name, address _wallet) public onlyOwner{
          if(farmerId[_wallet]==0) revert alreadyRegistered("already registered");
          Farmer memory f = Farmer(_name, _wallet, block.timestamp, true);
          farmer[_wallet]=f;
          registeredFarmers.push(_wallet);
          farmerId[_wallet]=registeredFarmers.length;
          emit FarmerRegistered(_name, _wallet);
          
    }

    function deactivateFarmer(address _farmerAddress) public onlyOwner{
        if(farmerId[_farmerAddress] ==0) revert farmerNotFound("farmer doesn't exist!");
        farmer[_farmerAddress].active = false;

    }

    function getFarmer(address _farmerAddress) public view returns(Farmer memory ) {
        if(farmerId[_farmerAddress] ==0) revert farmerNotFound("farmer doesn't exist!");
        return farmer[_farmerAddress];
    }

    // function getAllActiveFarmers() public view returns(address[] memory ){
    //     address[] memory activeFarmers;
    //     uint256 count;
    //     for(uint256 i=0; i<registeredFarmers.length;i++){
    //         if(farmer[registeredFarmers[i]].active){
    //             activeFarmers.push(registeredFarmers[i]);
    //         }

    //     }
    //     return activeFarmers;
    // }


}