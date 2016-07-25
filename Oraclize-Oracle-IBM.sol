// Ethereum + Solidity
// This pulls financial data from Yahoo
// and pushes it onto the blockchain


import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract IBMUSDfeed is usingOraclize {
  uint public IBM_USD;
    
  function IBMUSDfeed(){
    oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
    update(0); // first check at contract creation
  }
    
  function __callback(bytes32 myid, string result, bytes proof) {
    if (msg.sender != oraclize_cbAddress()) throw;
    IBM_USD = parseInt(result, 2); // save it as $ cents
    // do something with ETHUSD
    update(3600); // schedule another check in hour
  }
  
  function update(uint delay){
    // call oraclize and retrieve the latest IBM/USD price from Yahoo's YQL API
    // YQL == select LastTradePriceOnly from yahoo.finance.quote where symbol = "IBM"
    oraclize_query(delay, "URL",
      "json(https://query.yahooapis.com/v1/public/yql?q=select%20LastTradePriceOnly%20from%20yahoo.finance.quote%20where%20symbol%20%3D%20%22IBM%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys).query.results.quote.LastTradePriceOnly");
  }
}