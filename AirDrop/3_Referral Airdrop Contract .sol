pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract ReferralAirdrop {
    address public owner;
    uint256 public airdropAmount;
    mapping(address => address) public referrals;
    mapping(address => bool) public isAirdropped;

    constructor(address _owner, uint256 _airdropAmount) {
        owner = _owner;
        airdropAmount = _airdropAmount;
    }

    function airdropTokens(address _referredBy) public {
        require(!isAirdropped[msg.sender], "Sender has already received airdrop");
        require(_referredBy != address(0) && _referredBy != msg.sender, "Invalid referral address");

        isAirdropped[msg.sender] = true;
        IERC20(token).transfer(msg.sender, airdropAmount);

        if (referrals[_referredBy] == address(0)) {
            referrals[_referredBy] = msg.sender;
        }

        if (!isAirdropped[_referredBy]) {
            isAirdropped[_referredBy] = true;
            IERC20(token).transfer(_referredBy, airdropAmount);
        }

        if (referrals[msg.sender] == address(0)) {
            referrals[msg.sender] = _referredBy;
        }
    }

    function getReferralLink(address _referrer) public view returns (string memory) {
        bytes32 hash = keccak256(abi.encodePacked(_referrer));
        return string(abi.encodePacked("https://example.com/airdrop?ref=", hash));
    }
}
