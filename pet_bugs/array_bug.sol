contract Test_fails {
 
  struct Client {
    uint i;
    bytes32 n;
    uint b;
  }
  Client[] public clients;
 
  function addClient(uint _i, bytes32 _n, uint _b) {
    var c =  Client({i:_i, n: _n, b: _b});
    clients.push(c);
  }

}


contract Test_works {
 
  struct Client {
    uint i;
    bytes32 n;
  }
  Client[] public clients;
 
  function addClient(uint _i, bytes32 _n) {
    var c =  Client({i:_i, n: _n});
    clients.push(c);
  }

}