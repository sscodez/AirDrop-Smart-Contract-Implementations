pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract whitelistAirdrop {
    address public tokenAddress;
    uint256 public tokenAmount;

    mapping(address => bool) public whitelist;

    constructor(address _tokenAddress, uint256 _tokenAmount) {
        tokenAddress = _tokenAddress;
        tokenAmount = _tokenAmount;
    }

    function addToWhitelist(address _user) public {
        whitelist[_user] = true;
    }

    function removeFromWhitelist(address _user) public {
        whitelist[_user] = false;
    }

    function airdrop() public {
        IERC20 token = IERC20(tokenAddress);

        require(whitelist[msg.sender], "You are not whitelisted");
        require(token.balanceOf(address(this)) >= tokenAmount, "Insufficient balance of token");

        token.transfer(msg.sender, tokenAmount);
    }
}

