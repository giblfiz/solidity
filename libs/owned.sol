contract owned{
    address owner;
    
    function owned(){
        owner = msg.sender;
    }
    
    function checkOwnership() internal{
        if(msg.sender != owner){
            throw;
        }
    }
    
    function setOwner(address _a){
        checkOwnership();
        owner = _a;
    }
    
}
