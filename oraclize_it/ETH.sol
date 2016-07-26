// Ethereum + Solidity
// This code sample & more @ dev.oraclize.it

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract ETH is usingOraclize {
  uint public USD;
  uint public updated_time;
    
  function PriceFeed(){
    oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
    update(0); // first check at contract creation
    updated_time = block.timestamp;

  }
    
  function __callback(bytes32 myid, string result, bytes proof) {
    if (msg.sender != oraclize_cbAddress()) throw;
    USD = parseInt(result, 2); // save it as $ cents
  }
  
  function update(uint delay){
    oraclize_query(delay, "URL",
      "json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");
  }
}