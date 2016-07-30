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

//borrowed from @arachnid / Nick until I write my own
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
//        string memory copy = new string(5);
          uint k = 0;
        for (uint i = start; i < end; i++){ 
            bytes(copy)[k++] = bytes(_s)[i];
        }
        return copy;
    }
}
