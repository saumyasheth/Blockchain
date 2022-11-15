pragma solidity ^0.8.15;

contract banking{
    mapping(address => uint) balances;
    mapping(address => uint) timeofdep;
    event addbal(
        address acc, uint amount
    );
    event tran(
        address from, address to, uint amt
    );
    function ShowTotalBalance() view public returns(uint){
        uint bal=address(this).balance;
        return bal;
    }
    function ShowBalance(address balof) view public returns(uint){
        uint i = balances[balof]*(1 + ((7*((block.timestamp - timeofdep[balof])/2592000))/100)); //2592000 is number of seconds in a month
        return i;
    }
    function AddBalance() public payable{
        balances[msg.sender]+=msg.value;
        timeofdep[msg.sender]=block.timestamp;
        emit addbal(msg.sender , msg.value);
    }
    function Transfer(address toadd , uint amounttotransfer) public{
        balances[msg.sender] = balances[msg.sender]*(1 + ((7*((block.timestamp - timeofdep[msg.sender])/2592000))/100));
        require(balances[msg.sender]>=amounttotransfer , "not enough balance to transfer the given amount");
        balances[msg.sender]-=amounttotransfer;
        balances[toadd]+=amounttotransfer;
        emit tran(msg.sender , toadd , amounttotransfer);
    }
    function Withdraw(uint amounttowithdraw) public{
        balances[msg.sender] = balances[msg.sender]*(1 + ((7*((block.timestamp - timeofdep[msg.sender])/2592000))/100));
        address payable tomsgsender = payable(msg.sender);
        require(address(this).balance>=amounttowithdraw);
        tomsgsender.transfer(amounttowithdraw);
    }
}