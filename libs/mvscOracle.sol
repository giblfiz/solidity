//Version 0.4
import "github.com/giblfiz/solidity/libs/owned.sol";

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
        if( msg.value < 1) throw; //make sure they sent us enough to actually use
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
        if (!owner.send(this.balance)) throw; //lets harvest all the monies
        delete reqs;
    }

    function update(address _a, uint _v, string _t, string _e){
        checkOwnership();
        var caller = callerStub(_a);
        caller.__callback(_v, _t, _e);
    }    
}
