# SmartContract.sol
Midterm Part 1: Blockchain Supply Chain System
Developer: Trishia Mae L. Mañabat

Course/Year: BSIT-4A

Project Information
Project Title: Trishia Mae Poultrys Lifecycle Tracker

Selected Farm Business: Poultry (Chicken/Eggs Production)

Target Region: Central Luzon / Bocaue Supply Chain

Description of System
The Trishia Mae Poultrys system is a blockchain-based traceability solution designed to monitor the lifecycle of poultry products. By utilizing the Ethereum blockchain, the system ensures that every batch of eggs or chicken is tracked from the farm to the distributor with absolute transparency. This prevents data tampering and provides a verified audit trail for food safety and business integrity, allowing consumers and regulators to verify the origin and handling of poultry products in real-time.

Contract Features
Product Registration: Allows the authorized farmer to log new batches with unique IDs, pricing, quantity, and origin details.

Ownership Tracking: Real-time recording of the current holder (Farmer or Distributor) of the poultry batch.

Status Updates: A three-stage lifecycle: Created (0), InTransit (1), and Delivered (2).

Automatic Transfer Logic: When a product is transferred, the status is automatically updated to "In Transit" to maintain data accuracy without manual intervention.

Access Control: Secured functions using the Ownable pattern ensure only the "Farmer" can register products, and only the "Current Owner" can move or confirm delivery.

Data Retrieval: Public functions (getProduct and getHistory) to view full batch details and the complete ownership audit history.

Sample Test Steps (Execution Guide)
To validate the system for Midterm Part 1, follow these steps in Remix IDE:

1. Deployment (Access Control)
Action: Deploy the contract using the first address in Remix.

Verification: This address is now the "Authorized Farmer." Only this address can call registerProduct.

2. Product Registration (Requirement #1)
Action: Call registerProduct with:

_name: "Egg Batch A-101"

_quantity: 500

_price: 350

_origin: "Trishia Poultry Farm"

_date: "2026-03-26"

Verification: Status is set to 0 (Created).

3. Ownership Tracking (Requirement #2)
Action: Call products(1).

Verification: Confirm the currentOwner matches the Farmer's address.

4. Transfer Function (Requirement #4)
Action: Copy a Second Address. From the Farmer's account, call transferToDistributor(1, [Second_Address]).

Verification: Ownership shifts and status automatically moves to 1 (In Transit).

5. Access Control Test (Requirement #5)
Action: Switch to a Third Account and try to call markAsDelivered.

Verification: The transaction reverts, proving that unauthorized users cannot change product status.

6. Data Retrieval (Requirement #6)
Action: Call getHistory(1).

Verification: View the audit trail showing the Farmer address followed by the Distributor address.

Technical Conclusion
This system demonstrates how blockchain can eliminate the "trust gap" in local agriculture. By automating the status updates and strictly enforcing access control, the Trishia Mae Poultrys Lifecycle Tracker ensures that the data recorded on-chain is a "single source of truth" for all stakeholders in the poultry supply chain.
