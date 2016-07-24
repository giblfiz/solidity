contract Reciver{
    address public cash_from;
    string public comment;
    uint public cash_value;

    /* get's the comment passed to it, and records how much Wei came with it */
    function setComment(string newComment){
        cash_from = msg.sender;
        cash_value = msg.value;
        comment = newComment;
    }
}

contract Sender{
    /* Sends 20 Wei along with the message to the target address... should be reciver */
    function Relay(string message, address target){
        Reciver R = Reciver(target);
        R.setComment.value(20)(message);
    }
}

/*
> r
{
  address: "0x868f6a89d7ed448191d743ebe226b86b5058e709",
  allEvents: function(),
  cash_from: function(),
  cash_value: function(),
  comment: function(),
  setComment: function()
}
> var s = eth.contract([{"constant":false,"inputs":[{"name":"message","type":"string"},{"name":"target","type":"address"}],"name":"Relay","outputs":[],"type":"function"}]
.. ).at("0xdf2cd6d6c7c2ae5d6a39e853502903f09cddb343")
undefined
> 
> 
> eth.sendTransaction({from:me, to:s.address, value:web3.toWei(100, "szabo")})
"0xeed69415e65b068bac3cd02a5d838a48ff09df578359cc2a67f87312e7b6101c"
> 
> r.setComment.sendTransaction("Eleven from me",{from:me, value:11})
"0xa89c7ca82a7df32bccb35b9eecabed753f526ba1aa00efa785e40e7e1a683a54"
> 
> r.cash_from()
"0x53939de4ee95e908871644c47eff301857140bd7"
> r.comment()
"Eleven from me"
> r.cash_value()
11
> 
> eth.getBalance(s.address)
100000000000000
> s
{
  address: "0xdf2cd6d6c7c2ae5d6a39e853502903f09cddb343",
  Relay: function(),
  allEvents: function()
}

> s.Relay.sendTransaction("twenty from relay", s.address ,{from:me})
"0x0bebee42952d4614c0707042542545688ce30c9024da839374a1212ed6860e8c"
> eth.getBalance(s.address)
100000000000000
> r.cash_value()
11
> r.comment()
"Eleven from me"
> r.cash_from()
"0x53939de4ee95e908871644c47eff301857140bd7"
> 

*/