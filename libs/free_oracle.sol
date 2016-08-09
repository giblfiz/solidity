// There is a copy of this named eth2us¢ at 0xcf631a0c28b9ebcf4a94296e2f7ff050e1954f56 on testnet

contract free_oracle {
    uint public value; //The value of the oraclized thing, usually a price in usd
    uint public updated_time; //When was the value set?
    string public name; //name within the MVSC schema Probably stock ticker
    address owner; // who can make a change;

    function free_oracle(string _name){
        name = _name;
        owner = msg.sender;
    }

    function set(uint _v) {
        if(msg.sender != owner){
            throw;
        }
        value = _v;
        updated_time = block.timestamp;
    }

    function set_owner(address _owner) returns (string) {
        if(msg.sender != owner){
            throw;
        }
        owner = _owner;
    }
}
