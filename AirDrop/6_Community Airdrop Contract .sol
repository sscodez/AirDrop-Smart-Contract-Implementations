pragma solidity ^0.8.0;

import "./ERC20.sol";

contract CommunityAirdrop {
    
    ERC20 public token;  // ERC20 token contract address
    address public admin;  // Contract admin address
    uint256 public airdropAmount;  // Amount of tokens to be distributed in the airdrop
    mapping(address => bool) public isEligible;  // Mapping of eligible addresses
    
    constructor(address _tokenAddress, uint256 _airdropAmount) {
        token = ERC20(_tokenAddress);
        airdropAmount = _airdropAmount;
        admin = msg.sender;
    }
    
    function setEligible(address[] memory _eligibleAddresses) public {
        require(msg.sender == admin, "Only admin can set eligible addresses");
        for(uint i=0; i<_eligibleAddresses.length; i++) {
            isEligible[_eligibleAddresses[i]] = true;
        }
    }
    
    function claimAirdrop() public {
        require(isEligible[msg.sender], "You are not eligible for the airdrop");
        require(token.balanceOf(address(this)) >= airdropAmount, "Insufficient funds in contract");
        require(token.transfer(msg.sender, airdropAmount), "Token transfer failed");
        isEligible[msg.sender] = false;  // Mark user as claimed
    }
}

