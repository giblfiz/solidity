//Version 0.3

import "github.com/giblfiz/solidity/libs/owned.sol";

contract callerStub{
    function __callback(uint value, string target, string error){
    }
}

contract mvscOracle is owned{
    struct req{
        address callbackTo;
        uint gasValue;
        string stock;
    }
    
    req[] reqs;
    
    function mvscOracle(){
        owner = msg.sender;
    }
    
    function request(string _stock){
        var r = req({callbackTo:msg.sender,gasValue:msg.value, stock:_stock});
        reqs.push(r);
    }

    function getCaller(uint _n) returns (address){
        checkOwnership();
        if(reqs.length < _n){
            return 0x0;
        }
        return reqs[_n].callbackTo;
    }
    
    function getGasValue(uint _n) returns (uint){
        checkOwnership();
        return reqs[_n].gasValue;
    }

    function getName(uint _n) returns (string){
        checkOwnership();
        return reqs[_n].stock;
    }

    function clearReqs(){
        checkOwnership();
        delete reqs;
    }

    function update(address _a, uint _v, string _t, string _e){
        checkOwnership();
        var caller = callerStub(_a);
        caller.__callback(_v, _t, _e);
    }    
}
