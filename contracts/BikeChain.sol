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

    // Check in a bike

    // Get total duration of bike use

    // Get contract balance

    // Get rnter's balance

    // Set due amount
}