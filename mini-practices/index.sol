// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract index{
    address public owner;
    struct Task{
        string description;
        bool isCompleted;
        address assignee;
        uint256 deadline;
    }
    constructor(){
          owner=msg.sender;
    }
    modifier onlyOwner{
        require(msg.sender==owner,"only owner can create tasks!");
        _;
    }

    Task[] public tasks;
    mapping (address=>uint256[]) taskIndex;
    event taskCompleted(address, string);

    function createTask(string memory description, address assignee, uint256 deadline) public onlyOwner{
        Task memory t = Task(description, false,assignee,deadline);
        tasks.push(t);
        taskIndex[assignee].push(tasks.length-1);

    }

    function completeTask(uint256 taskId) public{
        require(msg.sender==tasks[taskId].assignee, "not allowed to update!");
        tasks[taskId].isCompleted=true;
        emit taskCompleted(msg.sender , tasks[taskId].description );

    }
    function getMyTasks() public view returns( Task[] memory ){
        uint256[] memory id = taskIndex[msg.sender];
        Task[] memory myTasks = new Task[](id.length);
        for(uint256 i=0;i<id.length;i++){
            myTasks[i]=tasks[id[i]];
        }
        return myTasks;
      }
    function getTaskCount()  public view returns(uint256 total){
        return tasks.length;
    } 
    function withdrawExpiredTasks(uint256 taskId) public onlyOwner{
        require(taskId < tasks.length , "id out of bund");
        require(block.timestamp > tasks[taskId].deadline && !tasks[taskId].isCompleted ,"task not expired or already done" );
       tasks[taskId]= tasks[tasks.length -1];
       taskIndex[tasks[taskId].assignee].push(taskId);
       tasks.pop();
    }

}