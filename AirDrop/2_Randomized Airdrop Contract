pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract RandomizedAirdrop {
    address public owner;
    uint256 public airdropAmount;
    uint256 public totalWeight;
    mapping(address => uint256) public weights;
    mapping(address => bool) public isAirdropped;

    constructor(address _owner, uint256 _airdropAmount) {
        owner = _owner;
        airdropAmount = _airdropAmount;
    }

    function addRecipient(address _recipient, uint256 _weight) public {
        require(msg.sender == owner, "Only contract owner can add recipients");
        require(_weight > 0, "Recipient weight must be greater than zero");
        weights[_recipient] = _weight;
        totalWeight += _weight;
    }

    function removeRecipient(address _recipient) public {
        require(msg.sender == owner, "Only contract owner can remove recipients");
        totalWeight -= weights[_recipient];
        delete weights[_recipient];
    }

    function updateRecipientWeight(address _recipient, uint256 _newWeight) public {
        require(msg.sender == owner, "Only contract owner can update recipient weights");
        require(_newWeight > 0, "Recipient weight must be greater than zero");
        totalWeight -= weights[_recipient];
        totalWeight += _newWeight;
        weights[_recipient] = _newWeight;
    }

    function airdropTokens() public {
        require(msg.sender == owner, "Only contract owner can initiate airdrop");
        require(totalWeight > 0, "Recipient weights must be greater than zero");

        uint256 randomValue = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, block.coinbase))) % totalWeight;

        for (uint i = 0; i < recipients.length; i++) {
            address recipient = recipients[i];
            if (!isAirdropped[recipient]) {
                randomValue -= weights[recipient];
                if (randomValue <= 0) {
                    isAirdropped[recipient] = true;
                    IERC20(token).transfer(recipient, airdropAmount);
                    break;
                }
            }
        }
    }
}
