// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.7;

contract CryptoKids{
    // Owner Dad
    address owner;

    event LogKidFundingReceived(address addr, uint amount, uint contractBalance);

    constructor() {
        owner = msg.sender;
    }

    //Define kids
    struct Kid {
        address payable walletAddress;
        string firstName;
        string lastName;
        uint releaseTime;
        uint amount;
        bool canWithdraw;
    }

    Kid[] public Kids;

    // Add kids to contract
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can add kids");
        _;
    }
    function addKid(address payable walletAddress, string memory firstName, string memory lastName, uint releaseTime, uint amount, bool canWithdraw) public onlyOwner {
        Kids.push(Kid(
            walletAddress,
            firstName,
            lastName,
            releaseTime,
            amount,
            canWithdraw
        ));
    }

    function balanceOf() public view returns(uint) {
        return address(this).balance;
    }

    // Deposite funds to contract, specofocally to a kid's account
    function deposite(address walletAddress) payable public {
        addToKidsBalance(walletAddress);
    }

    function addToKidsBalance(address walletAddress) private {
        for(uint i = 0; i < Kids.length; i++){
            if(Kids[i].walletAddress == walletAddress) {
                Kids[i].amount += msg.value;
                emit LogKidFundingReceived(walletAddress, msg.value, balanceOf());
            }
        }
    }

    function getIndex(address walletAddress) view private returns(uint) {
        for(uint i = 0; i < Kids.length; i++){
            if(Kids[i].walletAddress == walletAddress) {
                return i;
            }
        }
        return 999;
    }

    // Kid checks if able to withdraw
    function availableToWithdraw(address walletAddress) public returns(bool) {
        uint i = getIndex(walletAddress);
        require(block.timestamp > Kids[i].releaseTime, "You cannot withdraw yet");
        if (block.timestamp > Kids[i].releaseTime) {
            Kids[i].canWithdraw = true;
            return true;
        } else {
            return false;
        }
    }

    // Withdraw money
    function withdraw(address payable walletAddress) payable public {
        uint i = getIndex(walletAddress);
        require(msg.sender == Kids[i].walletAddress, "You must be the kid to withdraw");
        require(Kids[i].canWithdraw == true, "You are not able to withdraw at this time");
        Kids[i].walletAddress.transfer(Kids[i].amount);
    }
}

// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,Atuh,Samuel,1658482229,0,false