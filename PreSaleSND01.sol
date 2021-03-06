pragma solidity ^0.4.11;

contract PreSaleSND01 {
    address public beneficiary;
    uint public startline;
    uint public deadline;
    uint public price;
    uint public amountRaised;
    SNDToken public tokenReward;

    function PreSaleSND01(
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
        amountRaised += amount;
        tokenReward.transfer(msg.sender, amount / price);
    }

    function WithdrawAllETH() {
        if (beneficiary != msg.sender) throw;
        beneficiary.transfer(amountRaised);
    }

    function WithdrawETH(uint amount) {
        if (beneficiary != msg.sender) throw;
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
