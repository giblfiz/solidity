//This is my pet Bug!! 
//it's open at https://github.com/ethereum/solidity/issues 724#issuecomment-233352902
contract micro {

    struct R {
        uint  other;
        uint  count;
        uint  block_num;
    }

    mapping(address => R) public V;

    function broken() {
        var twenty = 20;
        V[msg.sender].other += 19;
        V[msg.sender].count += twenty;
        V[msg.sender].block_num = block.number;
        msg.sender.send(twenty);
    }

    function works() {
        var twenty = 20;
        V[msg.sender].count += twenty;
        V[msg.sender].block_num = block.number;
        msg.sender.send(twenty);
    }
}

//To experance this bug:
// Create the contract Micro on the blockchain
//
// Fund the contract with at least 40 Wei 
// > eth.sendTransaction({from:eth.accounts[0], to: micro.address, value:40})
// 
// Check the Balance (make sure you wait for it to mine)
// > eth.getBalance(micro.address)
//
// Check starting value of V for youself 
// > micro.V.call(eth.accounts[0])
//
// Now try calling Broken as a transaction..
// > micro.broken.sendTransaction({from:eth.accounts[0]})
//
// Check the Balance (make sure you wait for it to mine)... note how it hasn't gone down
// > eth.getBalance(micro.address)
//
// Check starting value of V for youself... note how it hasn't been updated
// > micro.V.call(eth.accounts[0])
//
// Now try calling works as a transaction..
// > micro.works.sendTransaction({from:eth.accounts[0]})
//
// Check the Balance (make sure you wait for it to mine)... note how it HAS gone down
// > eth.getBalance(micro.address)
//
// Check starting value of V for youself... note how it HAS been updated
// > micro.V.call(eth.accounts[0])
//
// Now try calling broken as a transaction again
// > micro.broken.sendTransaction({from:eth.accounts[0]})
//
// Check the Balance (make sure you wait for it to mine)... note how it HAS gone down
// > eth.getBalance(micro.address)
//
// Check starting value of V for youself... note how it HAS been updated
// > micro.V.call(eth.accounts[0])

