pragma solidity ^0.4.11;

/**
* @title Contract that will work with ERC223 tokens.
*/

contract ERC223ReceivingContract {

    function tokenFallback(address _sender, address _origin, uint256 _value, bytes _data) returns (bool success);
}