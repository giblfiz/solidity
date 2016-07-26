// Ethereum + Solidity
// This code sample & more @ dev.oraclize.it

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract IBM is usingOraclize {
  uint public USD;
  uint public updated_time;
    
  function IBM(){
    oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
    update(0); // first check at contract creation
  }
    
  function __callback(bytes32 myid, string result, bytes proof) {
    if (msg.sender != oraclize_cbAddress()) throw;
    USD = parseInt(result, 2); // save it as $ cents
    updated_time = block.timestamp;
  }
  
  function update(uint delay){
    // call oraclize and retrieve the latest IBM/USD price from Yahoo's YQL API
    // YQL == select LastTradePriceOnly from yahoo.finance.quote where symbol IBM 
    oraclize_query(delay, "URL",
      "json(https://query.yahooapis.com/v1/public/yql?q=select%20LastTradePriceOnly%20from%20yahoo.finance.quote%20where%20symbol%20%3D%20%22IBM%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys).query.results.quote.LastTradePriceOnly");
  }
}
