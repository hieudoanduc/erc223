pragma solidity ^0.4.11;

import './ERC20Basic.sol';

contract ERC223Interface  is ERC20Basic{
  function transfer(address _to, uint256 _value, bytes _data) returns (bool success);
  function contractFallback(address _origin, address _to, uint256 _value, bytes _data) internal returns (bool success);
  function isContract(address _address) internal returns (bool is_contract);
  event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
}