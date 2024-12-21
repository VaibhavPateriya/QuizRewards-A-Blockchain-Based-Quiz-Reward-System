// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract QuizRewards {
    address public owner;
    uint256 public rewardPerQuiz;
    mapping(address => uint256) public userBalances;

    event QuizCompleted(address indexed user, uint256 reward);
    event RewardClaimed(address indexed user, uint256 amount);

    constructor(uint256 _rewardPerQuiz) {
        owner = msg.sender;
        rewardPerQuiz = _rewardPerQuiz;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    function completeQuiz() external {
        userBalances[msg.sender] += rewardPerQuiz;
        emit QuizCompleted(msg.sender, rewardPerQuiz);
    }

    function claimRewards() external {
        uint256 rewardAmount = userBalances[msg.sender];
        require(rewardAmount > 0, "No rewards to claim");

        userBalances[msg.sender] = 0;
        payable(msg.sender).transfer(rewardAmount);

        emit RewardClaimed(msg.sender, rewardAmount);
    }

    function updateRewardPerQuiz(uint256 _newReward) external onlyOwner {
        rewardPerQuiz = _newReward;
    }

    function fundContract() external payable onlyOwner {}

    function withdrawFunds(uint256 _amount) external onlyOwner {
        require(_amount <= address(this).balance, "Insufficient balance");
        payable(owner).transfer(_amount);
    }

    receive() external payable {}
}
