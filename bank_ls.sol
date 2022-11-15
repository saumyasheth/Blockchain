// SPDX-License-Identifier: MIT
pragma solidity >0.8.7;

contract Bank {
    // uint totalBalance; //stores the balance in wei, we will give it and use ether value nonetheless
    mapping (address => uint) balances;
    mapping (address => uint) depositTimes;
    address payable BankAddress;
    constructor () {
        //totalBalance = (100 ether); 
        BankAddress = payable(address(this));
        // Balance of the Bank is the same as the amount of ether in the account that has 
        // called the contract
    }

    event BankMoney(string message, uint value);
    function showTotalBalance() public returns (uint){
        //emit BankMoney("Total balance in the bank was queried.", BankAddress.balance);
        return BankAddress.balance/(1 ether);
    }

    function interest(address owner) internal returns (uint){
        uint time_elapsed = block.timestamp - depositTimes[owner];
        // The interest is 7% per 10 seconds
        return time_elapsed*7*balances[owner]/(10*100);
    }

    event UserBalance(string message, uint value);
    function showBalance() public returns (uint){
        address owner = msg.sender;
        uint updated = balances[owner] + interest(owner);
        //emit UserBalance("User has queried about their bank balance.", balances[owner]);
        return updated/(1 ether);
    }

    event Transaction(string nature, uint money, address payable customer);
    function addBalance(address owner, uint money) internal returns (bool){
        balances[owner]+=money;
        depositTimes[owner] = block.timestamp;
        //emit Transaction("Deposit", money, owner);
        // BankAddress.transfer(money); no need to do this, money already in the contract, 
        // which is the bank
        return true;
    }

    function withdraw() public returns (bool){
        address payable owner = payable(msg.sender);
        balances[owner]+=interest(owner);
        owner.transfer(balances[owner]);
        emit Transaction("withdraw", balances[owner], owner);
        balances[owner]=0;
        return true;
    } 

    receive() external payable {
        addBalance(msg.sender, msg.value);
    }
    event Initialise(uint money, string message);
    event Fail (string bruh, string data);
    
    fallback() external payable {
        /*
        //string memory data = string(abi.encodePacked(msg.data));
        string init = "init";
        if (string(msg.data) == init){
            // The contract has now received money. 
            // We don't need to transfer it to the BankAddress.
            emit Initialise(BankAddress.balance, "The bank now has money.");
        }
        emit Fail("Not initialised", string(msg.data));
        */
        emit Initialise(BankAddress.balance, string(msg.data));
    }
}