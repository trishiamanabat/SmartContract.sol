// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TrishiaMaePoultrys
 * @author Trishia Mae
 * @notice 5. Access Control: Only authorized roles can register and transfer.
 */
contract TrishiaMaePoultrys is Ownable {
    
    // 3. Status Updates: Defining the lifecycle stages
    enum Status { Created, InTransit, Delivered }

    struct Product {
        uint256 id;
        string name;
        uint256 quantity;
        uint256 price;          // Bonus: Price Tracking
        string origin;
        string dateCreated;     // Bonus: Date Tracking
        address currentOwner;   // 2. Ownership Tracking
        Status currentStatus;   // 3. Status Updates
    }

    // 4 & 6. Storage for products and audit trails
    mapping(uint256 => Product) public products;
    mapping(uint256 => address[]) public ownershipHistory; 
    uint256 public productCount;

    // Events for transparency and off-chain logging
    event ProductRegistered(uint256 id, string name, address farmer);
    event OwnershipTransferred(uint256 id, address from, address to);
    event StatusUpdated(uint256 id, Status newStatus);

    constructor() Ownable(msg.sender) {}

    /**
     * @notice 1. Product Registration & 5. Access Control
     * Restricted to 'onlyOwner' (The Farmer: Trishia Mae).
     */
    function registerProduct(
        string memory _name, 
        uint256 _quantity, 
        uint256 _price, 
        string memory _origin,
        string memory _date
    ) public onlyOwner {
        productCount++;
        uint256 newId = productCount;

        products[newId] = Product({
            id: newId,
            name: _name,
            quantity: _quantity,
            price: _price,
            origin: _origin,
            dateCreated: _date,
            currentOwner: msg.sender,
            currentStatus: Status.Created
        });

        // 4. Record transaction history (Initial entry)
        ownershipHistory[newId].push(msg.sender);

        emit ProductRegistered(newId, _name, msg.sender);
    }

    /**
     * @notice 4. Transfer Function & 5. Access Control
     * Updates status to 'InTransit' automatically.
     */
    function transferToDistributor(uint256 _id, address _distributor) public {
        // 5. Access Control: Only the current owner can initiate transfer
        require(products[_id].currentOwner == msg.sender, "Not authorized: You do not own this batch.");
        require(products[_id].currentStatus == Status.Created, "Invalid Action: Batch must be in 'Created' status.");

        address previousOwner = products[_id].currentOwner;
        
        // 4. Update status automatically & Change owner
        products[_id].currentOwner = _distributor;
        products[_id].currentStatus = Status.InTransit; // Auto-update
        
        // 4. Record transaction history
        ownershipHistory[_id].push(_distributor);

        emit OwnershipTransferred(_id, previousOwner, _distributor);
        emit StatusUpdated(_id, Status.InTransit);
    }

    /**
     * @notice Final Status Update: Delivered
     */
    function markAsDelivered(uint256 _id) public {
        // 5. Access Control: Only the current holder (Distributor) can confirm arrival
        require(products[_id].currentOwner == msg.sender, "Not authorized: Only current holder can confirm.");
        
        products[_id].currentStatus = Status.Delivered;
        
        emit StatusUpdated(_id, Status.Delivered);
    }

    /**
     * @notice 6. Data Retrieval: View Product Details
     */
    function getProduct(uint256 _id) public view returns (Product memory) {
        return products[_id];
    }

    /**
     * @notice 6. Data Retrieval: View Ownership History
     */
    function getHistory(uint256 _id) public view returns (address[] memory) {
        return ownershipHistory[_id];
    }
}