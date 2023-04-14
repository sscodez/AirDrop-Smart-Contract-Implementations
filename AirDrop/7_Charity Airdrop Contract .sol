pragma solidity ^0.8.0;

import "./ERC20.sol";

contract CharityAirdrop {
    
    ERC20 public token;  // ERC20 token contract address
    address public admin;  // Contract admin address
    uint256 public airdropAmount;  // Amount of tokens to be distributed in the airdrop
    uint256 public charityPercentage;  // Percentage of tokens to be donated to charity
    address public charityAddress;  // Address of charity organization
    
    mapping(address => bool) public isEligible;  // Mapping of eligible addresses
    
    constructor(address _tokenAddress, uint256 _airdropAmount, uint256 _charityPercentage, address _charityAddress) {
        token = ERC20(_tokenAddress);
        airdropAmount = _airdropAmount;
        charityPercentage = _charityPercentage;
        charityAddress = _charityAddress;
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
        uint256 totalTokens = airdropAmount * 10**18;  // Convert to wei
        uint256 charityTokens = (totalTokens * charityPercentage) / 100;
        uint256 userTokens = totalTokens - charityTokens;
        require(token.balanceOf(address(this)) >= totalTokens, "Insufficient funds in contract");
        require(token.transfer(charityAddress, charityTokens), "Token transfer to charity failed");
        require(token.transfer(msg.sender, userTokens), "Token transfer to user failed");
        isEligible[msg.sender] = false;  // Mark user as claimed
    }
}

