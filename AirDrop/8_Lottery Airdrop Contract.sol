pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LotteryAirdrop is VRFConsumerBase {
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public numWinners;
    uint256 public tokenAmount;
    IERC20 public token;

    mapping(bytes32 => address[]) public participants;

    constructor(address _vrfCoordinator, address _link, bytes32 _keyHash, uint256 _fee, uint256 _numWinners, uint256 _tokenAmount, address _tokenAddress)
    VRFConsumerBase(_vrfCoordinator, _link) {
        keyHash = _keyHash;
        fee = _fee;
        numWinners = _numWinners;
        tokenAmount = _tokenAmount;
        token = IERC20(_tokenAddress);
    }

    function participate() public {
        participants[requestRandomness(keyHash, fee)] = [msg.sender];
    }

    function fulfillRandomness(bytes32 _requestId, uint256[] memory _randomNumbers) internal override {
        require(_randomNumbers.length == 1, "Invalid random number");

        address[] memory winners = new address[](numWinners);
        uint256 numParticipants = participants[_requestId].length;
        uint256[] memory indices = new uint256[](numParticipants);

        for (uint256 i = 0; i < numParticipants; i++) {
            indices[i] = i;
        }

        for (uint256 i = 0; i < numWinners; i++) {
            uint256 index = indices[_randomNumbers[0] % (numParticipants - i)];
            winners[i] = participants[_requestId][index];
            indices[index] = indices[numParticipants - i - 1];
        }

        for (uint256 i = 0; i < numWinners; i++) {
            token.transfer(winners[i], tokenAmount);
        }

        delete participants[_requestId];
    }
}

