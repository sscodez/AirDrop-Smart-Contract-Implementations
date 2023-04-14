
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract SocialMediaAirdrop {
    address public owner;
    uint256 public airdropAmount;
    mapping(address => bool) public isAirdropped;
    mapping(address => bool) public hasFollowedTwitter;
    mapping(address => bool) public hasRetweetedTweet;

    constructor(address _owner, uint256 _airdropAmount) {
        owner = _owner;
        airdropAmount = _airdropAmount;
    }

    function followTwitter() public {
        require(!hasFollowedTwitter[msg.sender], "Sender has already followed on Twitter");

        // Code to check if user has followed Twitter account
        // ...

        hasFollowedTwitter[msg.sender] = true;
    }

    function retweetTweet() public {
        require(!hasRetweetedTweet[msg.sender], "Sender has already retweeted the tweet");

        // Code to check if user has retweeted tweet
        // ...

        hasRetweetedTweet[msg.sender] = true;
    }

    function airdropTokens() public {
        require(!isAirdropped[msg.sender], "Sender has already received airdrop");
        require(hasFollowedTwitter[msg.sender], "Sender has not followed on Twitter");
        require(hasRetweetedTweet[msg.sender], "Sender has not retweeted the tweet");

        isAirdropped[msg.sender] = true;
        IERC20(token).transfer(msg.sender, airdropAmount);
    }
}
