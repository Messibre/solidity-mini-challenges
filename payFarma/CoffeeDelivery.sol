// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CoffeeDelivery{

    struct Delivery{
         uint256 dId;
         address farmerAddress;
         uint256 weight;
         uint256 quality;
         uint256 timestamp;
         bool paymentStatus;   
    }
    
    address owner2;
    // we will use delivery ID's as array index +1 
    mapping(address => uint256[]) deliveries;
    Delivery[] public allDeliveries;
    mapping(address=>bool) farmerRegistered;
    address[] public farmers;

    event deliveryLogged(address farmer);
    event deliveryPaid(uint256 deliveryId);

    constructor(){
        owner2=msg.sender;
    }
    modifier  onlyOwner2  {
        require(msg.sender==owner2, "only owner can do this!");
        _;
    }

    function logDelivery(address farmer, uint weight, uint8 grade) public onlyOwner2 {
        require(weight > 0, "invalid weight");
        require(grade >0 && grade <= 5 , "invalid grade");
        Delivery memory d = Delivery(allDeliveries.length+1 ,farmer, weight , grade , block.timestamp, false );
        deliveries[farmer].push(allDeliveries.length+1);
        allDeliveries.push(d);

        if(!farmerRegistered[farmer]){
            farmers.push(farmer);
            farmerRegistered[farmer]=true;
        }
           
        emit deliveryLogged(farmer);

    }

    function markDeliveryPaid(uint deliveryId) public onlyOwner2{
        require(deliveryId>0 && deliveryId<=allDeliveries.length, "Invalid Id!");
        require(allDeliveries[deliveryId-1].farmerAddress!=address(0), "Delivery not found");
        allDeliveries[deliveryId-1].paymentStatus=true;
        emit deliveryPaid(deliveryId);
    }

    function getFarmerDeliveries(address farmer) public view returns(Delivery[] memory){
        uint256[] memory ids = deliveries[farmer];
        Delivery[] memory myDeliveries = new Delivery[](ids.length);
        for(uint256 i=0;i<ids.length;i++){
            myDeliveries[i]=allDeliveries[ids[i]-1];
        }
        return myDeliveries;

    }

    function getTotalDelivered(address farmer) public view returns(uint256 , uint256 ){
        uint256[] memory ids = deliveries[farmer];
        uint256 paidKg;
        uint256 unpaidKg;
        for(uint256 i=0;i<ids.length;i++){
            if(allDeliveries[ids[i]-1].paymentStatus==true){
                paidKg += allDeliveries[ids[i]-1].weight;
            }else{
              unpaidKg += allDeliveries[ids[i]-1].weight;
            }
        }
        return (paidKg, unpaidKg);
    }
}