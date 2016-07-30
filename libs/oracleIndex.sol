import "github.com/giblfiz/solidity/libs/usingStdLib.sol";

contract oracleIndex is usingStdLib{
    struct mvsc_oricle { 
        address addr; 
        string description;
    }

    mapping(string => mvsc_oricle) map;
    string[] list;
    address owner;

    function oracleIndex(){
        owner = msg.sender;
    }

     //returns address of identified string
    function getAddress(string _n) returns (address){
        return map[_n].addr;
    }

     //returns human redable list of identifiers and descriptions
    function getList() returns (string){
        string memory result = "";
        for(uint i=0; i < list.length; i++){
            if (bytes(list[i]).length == 0){
                concat(result,list[i]);
                concat(result,":");
                concat(result,map[list[i]].description);
                concat(result,",  ");
            }
        }
        return result;
    }

    function addOracle(string _name, address _addr, string _desc){
        if(msg.sender != owner) throw;
        list.push(_name);
        map[_name] = mvsc_oricle({addr:_addr, description: _desc});
    }
    
    function removeOracle(string _name){
        for(uint i=0; i < list.length; i++){
            if(strEqualByValue(_name, list[i])){
                delete list[i];
                delete map[_name];
            }
        }
    }
}