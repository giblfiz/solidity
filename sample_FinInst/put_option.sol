pragma solidity 0.4.2;
import "github.com/giblfiz/solidity/libs/erc20.sol";

    //an option to sell assets at an agreed price on or before a particular date.
contract PutOption is ERC20{
    address public underlyingAsset; //the address of the underlying asset, should be ERC20
    address public backer;          //the publisher of this contract
    uint256 public strikePrice;     //the price that the asset can be sold at
    uint256 public expireTime;      //When these options are no longer valid
    string public name;             //automatically generated name

    event Exercise(address indexed _to, uint256 _amount);

    //constructor
    function PutOption( address _underlyingAsset, uint256 _strikePrice, uint256 _expireTime, uint8 _decimalUnits) {
        underlyingAsset = _underlyingAsset;
        backer = msg.sender;
        strikePrice = _strikePrice;
        expireTime = _expireTime;
        totalSupply = (this.balance / strikePrice);
        balances[msg.sender] = totalSupply;


//You know, I was going to do a bunch of name generation         
//        underlyingAsset_ ERC20 =  ERC20(_underlyingAsset); //You know, I was going to do a bunch 
//        var uaName = underlyingAsset_.name() 
          name = "Put Option @ _price_ on _ua_name_ on date";   // Set the name for display purposes
          decimals = _decimalUnits;                     // Amount of decimals for display purposes
          symbol = "Put@PriceºAssetºDate";                   // Set the symbol for display purposes
    }    
    
    //user povides tokens of the underlying asset, 
    //not to exceed the number of options they have
    //and get back ethereum 
    function exercise(uint amount){
        // Ensure that expireTime has not passed
        if (expireTime < block.timestamp)  throw;
        
        //ensure they own enough options to redeem this many options
        if (balances[msg.sender] < amount) throw;

        //caller should have "authorized" asset on U.A.
        ERC20 ua = ERC20(underlyingAsset);
        uint256 authorized = ua.allowance(msg.sender, this);
        if (amount > authorized) throw; // if they haven't given us enough, throw

        //(this) transfer U.A. of amount to (this)
        ua.transferFrom(msg.sender, this, amount);

        // remove the used options
        balances[msg.sender] -= amount ;

        //(this) transfer amount*strikePrice eth to caller
        if(!msg.sender.send(amount*strikePrice)) throw;

        //message the world
        Exercise(msg.sender, amount);
    } 

    //This allows the backer to withdraw any of
    // U.A. that has been exercized, and may be called frequently
    function withdrawAsset(){
        ERC20 ua = ERC20(underlyingAsset);
        uint256 balance = ua.balanceOf(backer);
        ua.transfer(backer, balance);
    }
    
    //This allows the backer to reclaim the eth 
    //they have been using to back their option
    //after it expires
    function cleanup(){
        // Ensure that expireTime has passed
        if (expireTime > block.timestamp)  throw;
        if(!backer.send(this.balance)) throw;
    }

}
