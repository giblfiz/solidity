//an ethereium faucet... gives away free ether
//also lets people contribute to it in order to play king of the hill with it's response message
contract faucet {
    address public largest_donor;
    uint public largest_donation;

    struct Recipient {
        uint amount_claimed;
        uint block_number;
    }

    mapping(address => Recipient) public recipients;

    function gimme() constant returns (string) {
        var one_pct = uint(this.balance / 100);

        if(recipients[msg.sender].amount_claimed > 0){
            var ok_block = recipients[msg.sender].block_number + recipients[msg.sender].amount_claimed;
            if (block.number < ok_block){
                throw;
            }
        }

        recipients[msg.sender].amount_claimed += one_pct;
        recipients[msg.sender].block_number = block.number;

        if(!msg.sender.send(one_pct)){
            throw;
        }
    }

    function sponsor(){
        if (msg.value > largest_donation){
            largest_donor = msg.sender;
            largest_donation = msg.value;
        }
    }
    
}