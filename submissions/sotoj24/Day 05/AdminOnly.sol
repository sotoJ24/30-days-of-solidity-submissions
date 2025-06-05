// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdminOnly {
    address public owner;
    uint public treasureBalance;

    mapping(address => bool) public approvedUsers;
    mapping(address => bool) public hasWithdrawn;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function depositTreasure() external payable onlyOwner {
        treasureBalance += msg.value;
    }


    function approveUser(address user) external onlyOwner {
        approvedUsers[user] = true;
    }


    function resetWithdrawals(address user) external onlyOwner {
        hasWithdrawn[user] = false;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }


    function withdraw() external {
        require(approvedUsers[msg.sender], "Not approved to withdraw");
        require(!hasWithdrawn[msg.sender], "Already withdrawn");
        require(treasureBalance > 0, "No treasure available");

        uint amount = treasureBalance / 10; 
        hasWithdrawn[msg.sender] = true;
        treasureBalance -= amount;

        payable(msg.sender).transfer(amount);
    }

    function getContractBalance() external view returns (uint) {
        return address(this).balance;
    }
}
