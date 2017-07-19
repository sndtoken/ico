pragma solidity ^0.4.12;

import "./BurnableToken.sol";
import "./UpgradeableToken.sol";

contract SNDToken is BurnableToken, UpgradeableToken {

  string public name;
  string public symbol;
  uint public decimals;
  address public owner;

  mapping(address => uint) previligedBalances;

  function SNDToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals)  UpgradeableToken(_owner) {
    name = _name;
    symbol = _symbol;
    totalSupply = _totalSupply;
    decimals = _decimals;

    // Allocate initial balance to the owner
    balances[_owner] = _totalSupply;

    // save the owner
    owner = _owner;
  }

  // privileged transfer
  function transferPrivileged(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
    if (msg.sender != owner) throw;
    balances[msg.sender] = safeSub(balances[msg.sender], _value);
    balances[_to] = safeAdd(balances[_to], _value);
    previligedBalances[_to] = safeAdd(previligedBalances[_to], _value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  // get priveleged balance
  function getPrivilegedBalance(address _owner) constant returns (uint balance) {
    return previligedBalances[_owner];
  }

  // admin only can transfer from the privileged accounts
  function transferFromPrivileged(address _from, address _to, uint _value) returns (bool success) {
    if (msg.sender != owner) throw;

    uint availablePrevilegedBalance = previligedBalances[_from];

    balances[_from] = safeSub(balances[_from], _value);
    balances[_to] = safeAdd(balances[_to], _value);
    previligedBalances[_from] = safeSub(availablePrevilegedBalance, _value);
    Transfer(_from, _to, _value);
    return true;
  }
}
