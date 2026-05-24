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
    mapping(address=>Farmer) public farmer;
    mapping(address=>uint256) public farmerId;
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
          if(farmerId[_wallet]!=0 && farmer[_wallet].active) revert alreadyRegistered("already registered");
          
          //if farmer exists but is deactivated -> activate
          if(farmerId[_wallet] != 0 && !farmer[_wallet].active){
            farmer[_wallet].active=true;
          }else{
          Farmer memory f = Farmer(_name, _wallet, block.timestamp, true);
          farmer[_wallet]=f;
          registeredFarmers.push(_wallet);
          farmerId[_wallet]=registeredFarmers.length+1;
          emit FarmerRegistered(_name, _wallet);}
          
    }

    function deactivateFarmer(address _farmerAddress) public onlyOwner{
        if(farmerId[_farmerAddress] ==0) revert farmerNotFound("farmer doesn't exist!");
        farmer[_farmerAddress].active = false;
        emit FarmerDeactivated(_farmerAddress);

    }

    function getFarmer(address _farmerAddress) public view returns(Farmer memory ) {
        if(farmerId[_farmerAddress] ==0) revert farmerNotFound("farmer doesn't exist!");
        return farmer[_farmerAddress];
    }

    function getAllActiveFarmers() public view returns(address[] memory ){
        uint256 count;
        for(uint256 i=0; i<registeredFarmers.length;i++){
            if(farmer[registeredFarmers[i]].active){
                count+=1;       
                     }

        }
        address[] memory activeFarmers= new address[](count);

        uint256 j=0;
        for(uint256 i=0; i<registeredFarmers.length;i++){
            if(farmer[registeredFarmers[i]].active){
                activeFarmers[j]=registeredFarmers[i];
                j++;

                }
        }

        return activeFarmers;
    }


}