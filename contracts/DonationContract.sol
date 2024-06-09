// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract DonationContract {
    // State variables
    address public owner;
    uint public totalDonations;
    mapping(address => uint) public donorAmounts;

    // Events
    event DonationReceived(address indexed donor, uint amount);
    event WithdrawalMade(address indexed admin, uint amount);

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Constructor sets the owner of the contract
    constructor() {
        owner = msg.sender;
    }

    // Function to handle receiving donations
    function donate() public payable {
        require(msg.value > 0, "Donation must be more than 0 wei");
        donorAmounts[msg.sender] += msg.value;
        totalDonations += msg.value;
        emit DonationReceived(msg.sender, msg.value);
    }

    // Function to withdraw funds from the contract
    function withdraw(uint _amount) public onlyOwner {
        require(_amount <= address(this).balance, "Insufficient funds");
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Failed to withdraw funds");
        emit WithdrawalMade(msg.sender, _amount);
    }

    // Function to check the balance of the contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
