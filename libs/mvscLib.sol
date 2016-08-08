import "github.com/giblfiz/solidity/libs/oracleIndex.sol";
import "github.com/giblfiz/solidity/libs/stdOracle.sol";

contract usingMvscLib {
    address oracleIndexAddr = 0x26c2ba17069b646e2b5f4e814279d7bdc6f1be73;
    string expectCallbackFrom;

    
    function getOracleAddress(string _oName) internal returns (address){
        oracleIndex oi = oracleIndex(oracleIndexAddr);
        return oi.getAddress(_oName);

    }
    function getOracle(string _oName) internal returns ( stdOracle) {
        stdOracle orcl =  stdOracle(getOracleAddress(_oName));
        return orcl;
    }

    // automatically calls out to the oracle, and asks it to update itself and make a callback 
    function oracleCallout(string _oName, uint gas){
        var orcl = getOracle(_oName);
        uint price = orcl.priceToUse();
        orcl.updateValue.value(price)();  
        expectCallbackFrom = _oName;
    }

    function __callback(){
        address orclAddr = getOracleAddress(expectCallbackFrom);
        if(msg.sender != orclAddr){
            throw;            
        }
        oracleCallback(getOracle(expectCallbackFrom));
    }

//    function oracleList() constant returns (string){
//        oracleIndex oi = oracleIndex(oracleIndexAddr);
//        string result = oi.getList();
//        return (oi); // wow, really? I totally don't understand memory vs literal vs ptr
//    }

    // this is a an abstract function that we need the user to build out 
    function oracleCallback(stdOracle);



//function oracleList(); // wrapper for getting the oracleList JSON via oracleIndex()
//function UsdToWei(); // converts us cents to wei, using a free(ish) oracle, that I think we should upkeep
//function WeiToUsd(); // see above, and use brain ###simpler stuff
//string functions (search, copyByValue, subStr, equalByValue, concat)

}
