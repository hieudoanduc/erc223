pragma solidity ^0.4.11;


import './ERC223Interface.sol';
import './ERC223ReceivingContract.sol';
import './BasicToken.sol';
import './Utils.sol';


/**
 * @title ERC223 standard token implementation.
 */
contract ERC223BasicToken is Utils, ERC223Interface,  BasicToken{

    /**
     * @dev Transfer the specified amount of tokens to the specified address.
     *      Invokes the `tokenFallback` function if the recipient is a contract.
     *      The token transfer fails if the recipient is a contract
     *      but does not implement the `tokenFallback` function
     *      or the fallback function to receive funds.
     *
     * @param _to    Receiver address.
     * @param _value Amount of tokens that will be transferred.
     * @param _data  Transaction metadata.
     */
    function transfer(address _to, uint256 _value, bytes _data)
    validAddress(_to)
    notThis(_to)
    greaterThanZero(_value)
    returns (bool success)
    {
        require(_to != address(0));
        require(balances[msg.sender] >=  _value);            // Ensure Sender has enough balance to send amount and ensure the sent _value is greater than 0
        require(balances[_to].add(_value) > balances[_to]);  // Detect balance overflow

        assert(super.transfer(_to, _value));               //@dev Save transfer

        if (isContract(_to)){
            return contractFallback(msg.sender, _to, _value, _data);
        }
        return true;
    }

    /**
     * @dev Transfer the specified amount of tokens to the specified address.
     *      This function works the same with the previous one
     *      but doesn't contain `_data` param.
     *      Added due to backwards compatibility reasons.
     *
     * @param _to    Receiver address.
     * @param _value Amount of tokens that will be transferred.
     */
    function transfer(address _to, uint256 _value)
    validAddress(_to)
    notThis(_to)
    greaterThanZero(_value)
    returns (bool success)
    {
        return transfer(_to, _value, new bytes(0));
    }


    /**
     * @dev Returns balance of the `_owner`.
     *
     * @param _owner   The address whose balance will be returned.
     * @return balance Balance of the `_owner`.
     */
    function balanceOf(address _owner)
    validAddress(_owner)
    constant returns (uint256 balance)
    {
        return super.balanceOf(_owner);
    }

    //function that is called when transaction target is a contract
    function contractFallback(address _origin, address _to, uint256 _value, bytes _data) internal returns (bool success) {
        ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
        return receiver.tokenFallback(msg.sender, _origin, _value, _data);
    }

    //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
    function isContract(address _address) internal returns (bool is_contract) {
        // retrieve the size of the code on target address, this needs assembly
        uint length;
        assembly {
            length := extcodesize(_address)
        }
        return length > 0;
    }
}
