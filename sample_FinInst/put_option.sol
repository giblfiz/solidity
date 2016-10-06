pragma solidity 0.4.2;

contract MyToken { 
    string public name;
    string public symbol;
    uint8 public decimals;
    mapping (address => uint256) public balanceOf;
    function MyToken(uint256 _supply, string _name, string _symbol, uint8 _decimals);
    function transfer(address _to, uint256 _value);
}

    //an option to sell assets at an agreed price on or before a particular date.
contract PutOption{
    address public underlyingAsset; //the address of the underlying asset, should be ERC20
    address public backer;          //the publisher of this contract
    uint256 public strikePrice;     //the price that the asset can be sold at
    uint256 public expireTime;      //When these options are no longer valid
    string public name;             //automatically generated name

    //constructor
    function PutOption(){
        
    }    
    
    //user povides tokens of the underlying asset, 
    //not to exceed the number of options they have
    //and get back ethereum 
    function exercise(uint amount){
        // Ensure that expireTime has not passed
        //caller should have "authorized" asset on U.A.
        //(this) transfer U.A. of amount to (this)
        //(this) transfer amount*strikePrice eth to caller
        //message the world
    } 

    //This allows the backer to withdraw any of
    // U.A. that they have been sold
    function withdrawAsset(){
        //send backer address all U.A.
    }    

}