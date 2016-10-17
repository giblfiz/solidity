//change this contract address to the one you have created!
var contractAddress = '0x3d8eddfcc85bd00c7d0b3426a0e030ad8de40527';

function createTransaction() {
    var receiverAddress = '0x' + document.querySelector('#receiverAddress').value;
    var amount = document.querySelector('#amount').value;
    var data = [receiverAddress, amount];
    web3.eth.transact({to: contractAddress, data: data, gas: 5000});
}

web3.eth.watch({altered: {at: web3.eth.accounts[0], id: contractAddress}}).changed(function() {
	document.getElementById('balance').innerText = web3.toDecimal(web3.eth.stateAt(contractAddress, web3.eth.accounts[0]));
    });