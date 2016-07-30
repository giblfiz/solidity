contract usingStdLib{
     function concat(string _a, string _b) internal returns (string){
        string memory result = new string(bytes(_a).length + bytes(_b).length);
        uint r_ptr = 0;
        for (uint i = 0; i < bytes(_a).length; i++){
            bytes(result)[r_ptr++] = bytes(_a)[i];
        }
        for (i = 0; i < bytes(_b).length; i++){
            bytes(result)[r_ptr++] = bytes(_b)[i];
        }
        return result;
    }

    
    function indexOf(string _haystack, string _needle) internal returns (int){
        bytes memory h = bytes(_haystack);
        bytes memory n = bytes(_needle);
        if(h.length < 1 || n.length < 1 || (n.length > h.length)){ 
            return -1;
        } else if(h.length > (2**128 -1)){
            return -1;                                  
        } else {
            uint subindex = 0;
            for (uint i = 0; i < h.length; i ++){
                if (h[i] == n[0]){
                    subindex = 1;
                    while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]){
                        subindex++;
                    } 
                    if(subindex == n.length){
                        return int(i);
                    }
                }
            }
            return -1;
        }   
    }
    
    
    /* written custom ... probably should actually be a wrapper around substr*/
    function strCopyByValue(string _s) internal returns (string){
        string memory copy = new string(bytes(_s).length);
        uint k = 0;
        for (uint i = 0; i < bytes(_s).length; i++){
            bytes(copy)[k++] = bytes(_s)[i]; 
        } 
        return copy;
    }
    
    function subStr(string _s, uint start) internal returns (string) {
        return(subStr(_s, start, bytes(_s).length));
    }
    
    function subStr(string _s, uint start, uint end) internal returns (string){
        bytes memory s = bytes(_s);
        string memory copy = new string(end - start);
        uint k = 0;
        for (uint i = start; i < end; i++){ 
            bytes(copy)[k++] = bytes(_s)[i];
        }
        

    }
    
}

contract example is usingStdLib{
    string public message; /* public means there will be an accessor method with the same name */

    /* public means there will be an accessor method with the same name, since
    this is an array, it will take one paramiter... the index*/
    string[] public oldMessages;
    uint wtf;
    
    /* A very simple function that sets the message */
    function setMessage(string _message){
        message = _message;
    }

    /* A function that sets the message, and returns the old message */
    function updateMessage(string _message) returns (string lastMessage){
        string memory myOldMessage = strCopyByValue(message);
        message = _message;
        return myOldMessage;
    }

    function bumpMessage(string _message) returns (string lastMessage){
        message = _message;
        return "wtf_lol";
    }

    
    /* an example of why a return value can be useful from a function that modifies data */
    function safeUpdateMessage(string _message){
        oldMessages.push(updateMessage(_message)); /* Store the result of updateMessage in oldMessage*/
    }

    function bumpUpdateMessage(string _message){
        oldMessages.push(bumpMessage(_message)); /* Store the result of updateMessage in oldMessage*/
    }

    function rollbackMessage(){
        message = oldMessages[oldMessages.length];
        delete oldMessages[oldMessages.length];
    }
    
    function packTheHistory(string _one, string _two, string _three, string _four){
        oldMessages.push(_one);
        oldMessages.push(_two);
        oldMessages.push(_three);
        oldMessages.push(_four);
    }
    
    function multiplyByTwo(uint number) returns (uint result){
        return (number * 2);
    }
}