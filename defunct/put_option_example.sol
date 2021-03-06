
import "github.com/giblfiz/solidity/oraclize_it/IBM.sol";
import "github.com/giblfiz/solidity/oraclize_it/ETH.sol";

//import "github.com/giblfiz/solidity/oraclize_it/testnet_directory.sol";



contract IBM_Put_Option{
    uint shares;
    uint strike_price;
    uint strike_time;
    uint purchase_price; 
    address writer; 
    address owner;

    function write_put( uint _shares, uint _strike_price, uint _strike_time, uint _purchase_price){
	    var backing_minimum  = _shares * _strike_price; //max contract could pay out for
 	    if (msg.value < backing_minimum) throw; // if it isn't "backed" for that much, don't make it

        shares = _shares;
        strike_price = _strike_price;
        strike_time = _strike_time;
        purchase_price = _purchase_price;

	    writer = msg.sender; //whoever mades it will get all leftover cash
	    owner = msg.sender; // whoever owns it has the option to exersize or sell, starts with creator
    }

    function buy_put(){
    	if (purchase_price == 0) throw;

	    var backing_minimum  = shares * strike_price;
    	if (this.balance < backing_minimum) throw;
    	
	    if (msg.value <= purchase_price) throw; //if they didn't pay enough for it, they don't get it.

	    if(!owner.send(msg.value)) throw; // Send the purchase price to the current owner.

	    owner = msg.sender; // and whoever paid the pruchase price now owns the contract

	    purchase_price = 0; // make the contract no longer for sale 
    }

    function sell_put(uint price){
    	purchase_price = price;
    }

    function exercise(){
    	if (block.timestamp > strike_time) throw; // Can't exersize after endtime 
    	
	    IBM ibm= IBM(ibm_addres());
	    ETH eth = ETH(eth_address()); //get usd per eth
	    asset_value_eth = ibm.usd() / eth.usd(); 	

        // if price is more than an hour out of date... don't do it!
        if(ibm.update_time() < block.timestamp - 3600) throw; 
        if(eth.update_time() < block.timestamp - 3600) throw; 

    	if(asset_value < strike_price){
	    	owner.send((strike_price - asset_value)*shares);
		    suicide(writer);
        }   
    }

    function close(){		
	    if (block.timestamp < strike_time) throw;
	    suicide(writer); 	
    }
    
    function update(){
        IBM ibm= IBM(ibm_addres());
	    ETH eth = ETH(eth_address()); //get usd per eth
        ibm.update();
        eth.update();

    }

    
}



		


