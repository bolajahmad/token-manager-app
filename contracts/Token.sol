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

// import relevant implemetation libraries
// ERC721 and ERC721URIStorage are useful for creating non-fungible tokens
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// Counters is useful for managin g token IDs that increase by a counf of 1 evertytime
import "@openzeppelin/contracts/utils/Counters.sol";

// define contract here. contract called Token
contract Token is ERC721URIStorage  {
    using Counters for IndexType;
    // declare private index using the Counter type
    IndexType private _tokenIds;

    // the fixed token
    uint256 public totalSupply = 100000000;
    mapping(address => uint256) balances; // create a mapping to store addresses and their balances

    constructor() public ERC721('MY_MAIN_TOKEN', 'MMT') {
        // the totalSupply of token is assigned to the transaction sender
        balances[msg.sender] = totalSupply;
        console.log("transaction sender", balances[msg.sender]);
    }

    // transfer tokens
    // given an address and also a token, send the token to the address
    function mintToken(address to, uint amount) external {
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