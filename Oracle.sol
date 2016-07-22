contract oracle {
    address public owner;
    uint private private_information;
    uint public last_updated;
    

    mapping(address => uint) public valid_until;


    function oracle(){
        private_information = 1;
        owner = 0x53939de4ee95e908871644c47eff301857140bd7;
    }

    function register() {
        //8,640 blocks per day , 1,000 finny per ether, 1,000,000 / szabo
        var blocks_paid = (msg.value / 10 szabo) ; //~ 11.5 days per ether
        
        if(valid_until[msg.sender] > block.number){
            //if they are currently registered, add about 1 day per ether
            valid_until[msg.sender] += blocks_paid;
        } else {
            valid_until[msg.sender] = block.number + blocks_paid;
        }       
    }


    function information() returns (uint info){
        if(valid_until[msg.sender] > block.number ){
            return private_information;
        } else {
            return 0;
        }
    }
    
    function set_private_information(uint info){
        if (msg.sender == owner){
            last_updated = block.number;
            private_information = info;
        } else {
            throw;
        }
    }
    
    function collect_value(){
        if(!owner.send(this.balance)){
            throw;
        }
    }
    
}
