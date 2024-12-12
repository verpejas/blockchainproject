pragma solidity ^0.8.0;

contract Marketplace {
    struct Object {
        uint id;
        string name;
        uint price;
        address owner;
    }

    uint public objectCount = 0;
    mapping(uint => Object) public objects;

    event ObjectCreated(uint id, string name, uint price, address owner);
    event OwnershipTransferred(uint id, address from, address to, uint price);

    // Create a new object
    function createObject(string memory _name, uint _price) public {
        objectCount++;
        objects[objectCount] = Object(objectCount, _name, _price, msg.sender);
        emit ObjectCreated(objectCount, _name, _price, msg.sender);
    }

    // Transfer ownership
    function transferOwnership(uint _id, address _newOwner) public payable {
        Object storage object = objects[_id];
        require(msg.sender == object.owner, "Not the owner");
        require(msg.value == object.price, "Incorrect value");

        payable(object.owner).transfer(msg.value);
        object.owner = _newOwner;

        emit OwnershipTransferred(_id, msg.sender, _newOwner, msg.value);
    }

    // Get object by ID
    function getObject(uint _id) public view returns (uint, string memory, uint, address) {
        Object memory object = objects[_id];
        return (object.id, object.name, object.price, object.owner);
    }

    // Update object price
    function updatePrice(uint _id, uint _newPrice) public {
        Object storage object = objects[_id];
        require(msg.sender == object.owner, "Not the owner");

        object.price = _newPrice;
    }
}
