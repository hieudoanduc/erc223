pragma solidity ^0.4.11;

import './ERC20.sol';

contract ERC223 is ERC20{
    function transferFrom(address _from, address _to, uint256 _value, bytes _data) returns (bool success);
}