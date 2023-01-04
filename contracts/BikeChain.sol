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
        uint due;
        uint start;
        uint end;
    }
    mapping (address => Renter) public renters;

    function addRenter(address payable walletAddress, string memory firstName, string memory lastName, bool canRent, bool active, uint due, uint start, uint end) public {
        renters[walletAddress] = Renter(walletAddress, firstName, lastName, canRent, active, due, start, end);
    }

    // Checkout bike
    function checkOut(address walletAddress) public {
        renters[walletAddress].active = true;
        renters[walletAddress].start = block.timestamp;
        renters[walletAddress].canRent = false;
    }

    // Check in a bike
    function checkIn(address walletAddress) public {
        renters[walletAddress].active = false;
        renters[walletAddress].end = block.timestamp;
        //renters[walletAddress].canRent = true;
    }

    // Get total duration of bike use
    function renterTimeSpan(uint start, uint end) internal pure returns(uint){
        return end - start;
    }
    function getTotalDuraion(address walletAddress) public view returns(uint) {
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
        return walletAddress.balance;
    }

    // Set due amount
}

// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,Atuh,Samuel,true,true,0,0,0
