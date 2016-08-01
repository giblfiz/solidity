import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";



contract stdOracle is usingOraclize {
  uint public value; //The value of the oraclized thing, usually a price in usd
  uint public updated_time; //When was the value set?
  uint public priceToUse; //how many Wei for us to take your contract 
  string public name; //name within the MVSC schema Probably stock ticker

  string query; //this is the call out, at the moment mostly to YUI
  address[] requestors; //list of users to be notified on update

  address owner; //who has update perms? 

}
