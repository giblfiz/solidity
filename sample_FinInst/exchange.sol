pragma solidity 0.4.2;
contract MyToken { 
    string public name;
    string public symbol;
    uint8 public decimals;
    mapping (address => uint256) public balanceOf;
    function MyToken(uint256 _supply, string _name, string _symbol, uint8 _decimals);
    function transfer(address _to, uint256 _value);
}

contract exchange {
    address public tokenAddrA;
    address public tokenAddrB;
    uint public Afor100B; // The exchange rate in <X> a's for 100 b's 
    
    address public ownerA;
    address public ownerB;

    function exchange(address _a, address _b, uint _rate){
        tokenAddrA = _a;
        tokenAddrB = _b;
        Afor100B = _rate;
    }

    function offerA(){
        if (ownerA == 0x0){
            ownerA = msg.sender;
        } else {
            throw;
        }
    }

    function offerB(){
        if (ownerB == 0x0){
            ownerB = msg.sender;
        } else {
            throw;
        }
    }
 
    function A() returns (uint){
        MyToken tokenA = MyToken(tokenAddrA);
        return tokenA.balanceOf(this);
    }
    
    function B() returns (uint){
        MyToken tokenB = MyToken(tokenAddrB);
        return tokenB.balanceOf(this);
    }

    event LogTransfer(address tokenType, address accountAddress, uint amount);


    function execute(){
        if (ownerB == 0x0) throw;
        if (ownerA == 0x0) throw;
        
        MyToken tokenA = MyToken(tokenAddrA);
        uint a = tokenA.balanceOf(this);
        
        MyToken tokenB = MyToken(tokenAddrB);
        uint b = tokenB.balanceOf(this);
        
        if ((a* Afor100B) > b*100){
          uint leftover_a = (((a*Afor100B)-(b*100))/(a*Afor100B));
          tokenA.transfer(ownerA,leftover_a);
          tokenA.transfer(ownerB,a - leftover_a);
          tokenB.transfer(ownerA,b );
          
          LogTransfer(tokenAddrA, ownerA, leftover_a);
          LogTransfer(tokenAddrA, ownerB, a - leftover_a);
          LogTransfer(tokenAddrB, ownerA, b);
        } else {
          uint leftover_b = (((b*100)-(a*Afor100B))/(b*100));
          tokenB.transfer(ownerB,leftover_b);
          tokenB.transfer(ownerA,b - leftover_b);
          tokenA.transfer(ownerB, a);

          LogTransfer(tokenAddrB, ownerB, leftover_b);
          LogTransfer(tokenAddrB, ownerA, b - leftover_b);
          LogTransfer(tokenAddrA, ownerB, a);
        }
        
        delete ownerA;
        delete ownerB;
        
    }
    
}