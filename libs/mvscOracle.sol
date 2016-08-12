import "github.com/giblfiz/solidity/libs/owned.sol";


contract callerStub{
    function __callback(){
    }
}

contract mvscOracle is owned{
    string public name;
    uint public value;
    
    address callbackTo;
    uint gasValue;
    
    function mvscOracle(string _n){
        owner = msg.sender;
        name = _n;
    }
    
    function request(){
        callbackTo = msg.sender;
        gasValue = msg.value;
    }

    function getCaller() returns (address){
        checkOwnership();
        return callbackTo;
    }
    
    function getGasValue() returns (uint){
        checkOwnership();
        return gasValue;
    }

    function update(uint _v){
        checkOwnership();
        value = _v;
        var caller = callerStub(callbackTo);
        caller.__callback();
        callbackTo = 0x0;
    }    
}
