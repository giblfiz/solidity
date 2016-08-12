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
    
    function setOwner(){
        checkOwnership();
        owner = msg.sender;
    }
    
}
