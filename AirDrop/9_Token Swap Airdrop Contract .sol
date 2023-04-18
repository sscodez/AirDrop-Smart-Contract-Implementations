pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract TokenSwapAirdrop {
    address public tokenAddress;
    uint256 public airdropAmount;
    uint256 public totalAirdropAmount;
    mapping(address => bool) public claimed;
    
    constructor(address _tokenAddress, uint256 _airdropAmount) {
        tokenAddress = _tokenAddress;
        airdropAmount = _airdropAmount;
    }
    
    function swapTokens() external {
        require(!claimed[msg.sender], "Already claimed");
        
        uint256 balance = IERC20(tokenAddress).balanceOf(msg.sender);
        require(balance > 0, "No tokens to swap");
        
        require(IERC20(tokenAddress).transferFrom(msg.sender, address(this), balance), "Transfer failed");
        
        claimed[msg.sender] = true;
        totalAirdropAmount += airdropAmount;
        
        require(IERC20(tokenAddress).transfer(msg.sender, airdropAmount), "Airdrop failed");
    }
}
