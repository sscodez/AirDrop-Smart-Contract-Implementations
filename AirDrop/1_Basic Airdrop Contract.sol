pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract BasicAirdrop {
    address public owner;
    uint256 public airdropAmount;
    mapping(address => bool) public isAirdropped;

    constructor(address _owner, uint256 _airdropAmount) {
        owner = _owner;
        airdropAmount = _airdropAmount;
    }

    function airdropTokens(address[] memory _recipients) public {
        require(msg.sender == owner, "Only contract owner can airdrop tokens");

        for (uint i = 0; i < _recipients.length; i++) {
            address recipient = _recipients[i];
            if (!isAirdropped[recipient]) {
                isAirdropped[recipient] = true;
                IERC20(token).transfer(recipient, airdropAmount);
            }
        }
    }
}
