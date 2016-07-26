// Ethereum + Solidity
// This code sample & more @ dev.oraclize.it

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract PriceFeed is usingOraclize {
  uint public ETHUSD;
    
  function PriceFeed(){
    oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
    update(0); // first check at contract creation
  }
    
  function __callback(bytes32 myid, string result, bytes proof) {
    if (msg.sender != oraclize_cbAddress()) throw;
    ETHUSD = parseInt(result, 2); // save it as $ cents
    // do something with ETHUSD
    update(60); // schedule another check in 60 seconds
  }
  
  function update(uint delay){
    oraclize_query(delay, "URL",
      "json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");
  }
}