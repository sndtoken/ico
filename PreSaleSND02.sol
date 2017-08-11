pragma solidity ^0.4.11;

contract PreSaleSND02 {
    address public beneficiary;
    uint public startline;
    uint public deadline;
    uint public price;
    SNDToken public tokenReward;

    function PreSaleSND02(
        uint start,
        uint end,
        uint costOfEachToken,
        SNDToken addressOfTokenUsedAsReward
    ) {
        beneficiary = msg.sender;
        startline = start;
        deadline = end;
        price = costOfEachToken;
        tokenReward = SNDToken(addressOfTokenUsedAsReward);
    }

    function () payable {
        if (now <= startline) throw;
        if (now >= deadline) throw;
        uint amount = msg.value;
        if (amount < price) throw;
        tokenReward.transfer(msg.sender, amount / price);
        beneficiary.transfer(amount);
    }

    function WithdrawSND(uint amount) {
        if (beneficiary != msg.sender) throw;
        tokenReward.transfer(beneficiary, amount);
    }

    function ChangeCost(uint costOfEachToken) {
        if (beneficiary != msg.sender) throw;
        price = costOfEachToken;
    }

    function ChangeStart(uint start) {
        if (beneficiary != msg.sender) throw;
        startline = start;
    }

    function ChangeEnd(uint end) {
        if (beneficiary != msg.sender) throw;
        deadline = end;
    }
}
