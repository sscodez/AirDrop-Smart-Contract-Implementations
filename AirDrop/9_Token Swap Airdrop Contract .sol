pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract TokenSwapAirdrop {
    address public token1Address;
    address public token2Address;
    uint256 public token1Amount;
    uint256 public token2Amount;

    constructor(address _token1Address, address _token2Address, uint256 _token1Amount, uint256 _token2Amount) {
        token1Address = _token1Address;
        token2Address = _token2Address;
        token1Amount = _token1Amount;
        token2Amount = _token2Amount;
    }

    function swap() public {
        IERC20 token1 = IERC20(token1Address);
        IERC20 token2 = IERC20(token2Address);

        require(token1.balanceOf(msg.sender) >= token1Amount, "Insufficient balance of token1");
        require(token2.balanceOf(address(this)) >= token2Amount, "Insufficient balance of token2");

        token1.transferFrom(msg.sender, address(this), token1Amount);
        token2.transfer(msg.sender, token2Amount);
    }
}

