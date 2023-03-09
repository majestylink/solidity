// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.7;

contract BikeChain {

    address owner;

    constructor() {
        owner = msg.sender;
    }
    // Add youself as a renter
    struct Renter {
        address payable walletAddress;
        string firstName;
        string lastName;
        bool canRent;
        bool active;
        uint balance;
        uint due;
        uint start;
        uint end;
    }
    mapping (address => Renter) public renters;

    function addRenter(address payable walletAddress, string memory firstName, string memory lastName, bool canRent, bool active, uint balance, uint due, uint start, uint end) public {
        renters[walletAddress] = Renter(walletAddress, firstName, lastName, canRent, active, balance, due, start, end);
    }

    // Checkout bike
    function checkOut(address walletAddress) public {
        require(renters[walletAddress].due == 0, "You have a pending balance");
        require(renters[walletAddress].canRent == true, "You can not rent at this time.");
        renters[walletAddress].active = true;
        renters[walletAddress].start = block.timestamp;
        renters[walletAddress].canRent = false;
    }

    // Check in a bike
    function checkIn(address walletAddress) public {
        require(renters[walletAddress].active == true, "Please checkout a bike first.");
        renters[walletAddress].active = false;
        renters[walletAddress].end = block.timestamp;
        //renters[walletAddress].canRent = true;
        setDue(walletAddress);
    }

    // Get total duration of bike use
    function renterTimeSpan(uint start, uint end) internal pure returns(uint){
        return end - start;
    }
    function getTotalDuraion(address walletAddress) public view returns(uint) {
        require(renters[walletAddress].active == false, "Bike is currently checked out.");
        uint timespan = renterTimeSpan(renters[walletAddress].start, renters[walletAddress].end);
        uint timeInMinutes = timespan / 60;
        return timeInMinutes;
    }

    // Get contract balance
    function balanceOf() public view returns(uint) {
        return address(this).balance;
    }

    // Get rnter's balance
    function balanceOfRenter(address walletAddress) public view returns(uint) {
        return renters[walletAddress].balance;
    }

    // Set due amount
    function setDue(address walletAddress) internal {
        uint timeInMinutes = getTotalDuraion(walletAddress);
        uint fiveMinuteIncrements = timeInMinutes / 5;
        renters[walletAddress].due = fiveMinuteIncrements * 5000000000000000;
    }

    function canRentBike(address walletAddress) public view returns(bool) {
        return renters[walletAddress].canRent;
    }

    // Deposit
    function deposit(address walletAddress) payable public {
        renters[walletAddress].balance += msg.value;
    }

    // Make Payment
    function makePayment(address walletAddress) payable public {
        require(renters[walletAddress].due > 0, "You not have anything due at this time");
        require(renters[walletAddress].balance > msg.value, "Insuficient balance, please make deposit");
        renters[walletAddress].balance -= msg.value;
        renters[walletAddress].canRent = true;
        renters[walletAddress].due = 0;
        renters[walletAddress].start = 0;
        renters[walletAddress].end = 0;
    }
}

// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,"Atuh","samuel",true,false,0,0,0,0
