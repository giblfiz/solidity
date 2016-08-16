import "github.com/giblfiz/solidity/libs/mvscOracle.sol";
import "github.com/giblfiz/solidity/libs/freeOracle.sol";

contract usingMvscLib is mvscOracleCaller {
    address mvscOracleAddr = 0x9f23678fa0b2ce34e995988fd2a464b1a182f467;
    address freeOracleAddr = 0x0a852a626e3f13a5e1d9a3b165e76f23c86379d5;

    function oracleCallout(string _stockName, uint gasValue){
        var orcl = mvscOracle(mvscOracleAddr);
        orcl.request.value(gasValue)(_stockName);  
    }

    function __callback(uint value, string target, string error){
        if(msg.sender != mvscOracleAddr){
           throw;            
        }
        oracleCallback(value, target);
    }


    // this is a an abstract function that we need the user to build out 
    function oracleCallback(uint value, string target);

    function usCentsToWei(uint uscents) constant returns (uint){
        freeOracle orcl =  freeOracle(0xcf631a0c28b9ebcf4a94296e2f7ff050e1954f56);
        return ((uscents * 1 ether ) / orcl.value());
    }

    function weiToUsCents(uint _wei) constant returns (uint){
        freeOracle orcl =  freeOracle(0xcf631a0c28b9ebcf4a94296e2f7ff050e1954f56);
        return ((_wei * orcl.value() )/ (1 ether));
    }

    function usdToWei(uint usd) constant returns (uint){
        return usCentsToWei(usd * 100);
    }
    
    function weiToUsd(uint _wei) constant returns(uint){
        return (weiToUsCents(_wei)/100);        
    }
}
