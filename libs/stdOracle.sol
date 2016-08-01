import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";



contract stdOracle is usingOraclize {
  uint public value; //The value of the oraclized thing, usually a price in usd
  uint public updated_time; //When was the value set?
  uint public priceToUse; //how many Wei for us to take your contract 
  string public name; //name within the MVSC schema Probably stock ticker

  string query; //this is the call out, at the moment mostly to YUI
  address[] requestors; //list of users to be notified on update

  address owner; //who has update perms? 


  function stdOracle(string _name){
    name = _name; //something like "IBM", "AAPL", or "FB"
    owner = msg.sender;
    priceToUse = 10 finney;
    oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
    
    // YQL == select LastTradePriceOnly from yahoo.finance.quote where symbol IBM 
    var start = "json(https://query.yahooapis.com/v1/public/yql?q=select%20LastTradePriceOnly%20from%20yahoo.finance.quote%20where%20symbol%20%3D%20%22";
    var end = "%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys).query.results.quote.LastTradePriceOnly";
    query = strConcat(start,name,end);
    
    //todo: put auto-registration in place... something like
    // registrar reg = registrar(someaddress)
    // reg.register(name, this)
    
  }
    
  function __callback(bytes32 myid, string result, bytes proof) {
    if (msg.sender != oraclize_cbAddress()) throw;
    value = parseInt(result, 2); // save it as $ cents
    updated_time = block.timestamp;
    
    for (uint i = 0; i < requestors.length; i++){
        origen o = origen(requestors[i]);
        o.__callback(name);
    }
    delete requestors;
  }
  
   function updateValue(){
    if(msg.value < priceToUse ){
        throw; // pay for use! 
    }
    // call oraclize and retrieve the latest price from Yahoo's YQL API
    oraclize_query(0, "URL", query); //delay set to zero, Maybe play with spare gas options later.
    requestors.push(msg.sender);    
  }
  // Fix the query if for some reason it's broken. 
  function setQuery(string _q){
      if(msg.sender != owner) throw;
      query = _q;
  }

// get the collected fee's out! 
  function collectPayment(uint amt){
      if(msg.sender != owner) throw;
      if(!msg.sender.send(amt)) throw;
  }
  
}

contract origen{
    function __callback(string _name){} 


}
