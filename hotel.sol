// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract HotelRoom{
    address payable owner;
    uint public price;
    enum Status {Vacant, Occupied}
    Status roomStatus;
    constructor (uint _price) {
        price = _price;
        roomStatus = Status.Vacant;
        owner = payable(msg.sender);
    }

    modifier onlyWhileVacant {
        require(roomStatus == Status.Vacant, "Room is already occupied"); //check room status
        _;
    }

    event Occupy(address customer, uint payment);

    function book() public payable onlyWhileVacant {
        require(msg.value >= price, "Fund deficit"); //check price
        owner.transfer(msg.value);
        roomStatus = Status.Occupied;
        emit Occupy(msg.sender, msg.value);
    }
}