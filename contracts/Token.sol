//SPDX-License-Identifier: Unlicense
// validate solidity version
pragma solidity ^0.8.0;

//this token contract should
// There is a fixed total supply of tokens that can't be changed.
// The entire supply is assigned to the address that deploys the contract.
// Anyone can receive tokens.
// Anyone with at least one token can transfer tokens.
// The token is non-divisible. You can transfer 1, 2, 3 or 37 tokens but not 2.5.

import "hardhat/console.sol";

// define contract here. contract called Token
contract Token {
    // string variables to identify the tokens
    string public name = "MY_MAIN_TOKEN";
    string public symbol = "MMT";

    // the fixed token
    uint256 public totalSupply = 100000000;
    address public owner;           // this owner will store the sender's address
    mapping(address => uint256) balances; // create a mapping to store addresses and their balances

    constructor() {
        // the totalSupply of token is assigned to the ctransaction sender
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
        console.log("transaction sender", balances[msg.sender]);
    }

    // transfer tokens
    // given an address and also a token, send the token to the address
    function sendToken(address to, uint amount) external {

        // verify that the sender's balance is enough
        require(balances[msg.sender] >= amount, "Not enough Tokens");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        console.log("transaction sender", balances[msg.sender]);
    }

    function getBalance(address account) external view returns (uint256) {
        console.log("balances", account);
        return balances[account];
    }
}