pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract StakingAirdrop {
    address public owner;
    uint256 public airdropAmount;
    uint256 public stakingPeriod;
    mapping(address => uint256) public stakes;
    mapping(address => uint256) public lastStakedTime;
    mapping(address => bool) public isAirdropped;

    constructor(address _owner, uint256 _airdropAmount, uint256 _stakingPeriod) {
        owner = _owner;
        airdropAmount = _airdropAmount;
        stakingPeriod = _stakingPeriod;
    }

    function stakeTokens(uint256 _amount) public {
        require(_amount > 0, "Amount must be greater than 0");

        IERC20(token).transferFrom(msg.sender, address(this), _amount);

        stakes[msg.sender] += _amount;
        lastStakedTime[msg.sender] = block.timestamp;
    }

    function airdropTokens() public {
        require(!isAirdropped[msg.sender], "Sender has already received airdrop");
        require(stakes[msg.sender] > 0, "Sender has no stake");

        uint256 timeSinceLastStaked = block.timestamp - lastStakedTime[msg.sender];
        require(timeSinceLastStaked >= stakingPeriod, "Staking period has not elapsed");

        isAirdropped[msg.sender] = true;
        uint256 airdropReward = (stakes[msg.sender] * airdropAmount) / totalStakes();
        IERC20(token).transfer(msg.sender, airdropReward);
    }

    function totalStakes() public view returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 0; i < addresses.length; i++) {
            total += stakes[addresses[i]];
        }
        return total;
    }
}

