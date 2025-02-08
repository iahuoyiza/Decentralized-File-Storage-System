# Decentralized File Storage System

A distributed storage protocol enabling secure file storage, encryption, automated payments, and node reputation management across a decentralized network.

## System Architecture

The system consists of four core smart contracts:

### 1. Storage Contract (StorageManager.sol)
- File upload management
- Content addressing
- Storage allocation
- Retrieval coordination
- Data availability tracking

### 2. Encryption Contract (EncryptionManager.sol)
- File encryption/decryption
- Access control management
- Key distribution
- Permission management
- Secure sharing mechanisms

### 3. Payment Contract (StoragePayments.sol)
- Storage space payments
- Automated billing
- Node compensation
- Payment verification
- Refund management

### 4. Node Reputation Contract (NodeReputation.sol)
- Node reliability tracking
- Performance metrics
- Uptime monitoring
- Quality scoring
- Penalty enforcement

## Technical Specifications

### Core Interfaces

#### Storage Interface
```solidity
interface IStorageManager {
    function uploadFile(
        bytes32 fileHash,
        uint256 fileSize,
        string memory metadata,
        address[] memory selectedNodes
    ) external returns (uint256 fileId);

    function retrieveFile(
        uint256 fileId
    ) external view returns (
        bytes32 fileHash,
        address[] memory storageNodes
    );
}
```

#### Encryption Interface
```solidity
interface IEncryptionManager {
    function encryptFile(
        uint256 fileId,
        bytes memory encryptionKey,
        address[] memory authorizedUsers
    ) external;

    function grantAccess(
        uint256 fileId,
        address user
    ) external;

    function revokeAccess(
        uint256 fileId,
        address user
    ) external;
}
```

### Configuration Parameters
```javascript
const storageConfig = {
    minimumFileSize: 1024,           // 1KB
    maximumFileSize: 1024 * 1024 * 1024, // 1GB
    replicationFactor: 3,            // Copies per file
    nodeMinUptime: 0.95,             // 95% availability
    paymentInterval: 2592000,        // 30 days
    gracePeriod: 259200,             // 3 days
    challengeInterval: 3600          // 1 hour
};
```

## Security Features

### Data Protection
1. End-to-end encryption
2. Redundant storage
3. Access control lists
4. Secure key management
5. Data integrity verification

### Node Security
- Performance monitoring
- Challenge verification
- Stake requirements
- Slashing conditions

## Deployment Guide

### Prerequisites
- Solidity ^0.8.0
- Hardhat/Truffle
- IPFS Integration
- OpenZeppelin Contracts

### Installation
```bash
# Install dependencies
npm install @openzeppelin/contracts
npm install ipfs-http-client
npm install hardhat

# Compile contracts
npx hardhat compile
```

## Usage Examples

### Uploading a File
```solidity
function uploadEncryptedFile(
    bytes32 fileHash,
    uint256 fileSize,
    bytes memory encryptedKey
) external {
    // Select storage nodes
    address[] memory nodes = nodeSelector.getAvailableNodes(
        fileSize,
        storageConfig.replicationFactor
    );
    
    // Upload file
    uint256 fileId = storageManager.uploadFile(
        fileHash,
        fileSize,
        encodeMetadata(fileSize, block.timestamp),
        nodes
    );
    
    // Setup encryption
    encryptionManager.encryptFile(
        fileId,
        encryptedKey,
        [msg.sender]
    );
}
```

### Storage Node Management
```solidity
function registerStorageNode(
    uint256 stake,
    uint256 storageCapacity
) external {
    require(stake >= MIN_STAKE, "Insufficient stake");
    
    nodeReputation.registerNode(
        msg.sender,
        storageCapacity,
        stake
    );
}
```

## Event System

### Storage Events
```solidity
event FileUploaded(
    uint256 indexed fileId,
    bytes32 fileHash,
    uint256 size
);

event AccessGranted(
    uint256 indexed fileId,
    address user
);

event NodeRegistered(
    address indexed node,
    uint256 capacity
);

event PaymentProcessed(
    address indexed node,
    uint256 amount
);
```

## Node Reputation System

### Scoring Metrics
- Uptime percentage
- Response time
- Storage reliability
- Challenge success rate

### Challenge Mechanism
1. Random file verification
2. Proof generation
3. Response validation
4. Score update

## Payment System

### Payment Flows
- Prepaid storage
- Usage-based billing
- Node rewards
- Stake management

### Price Calculation
- Storage duration
- File size
- Replication factor
- Node quality

## Testing Framework

### Test Categories
1. File operations
2. Node management
3. Payment processing
4. Encryption system
5. Challenge mechanism

```bash
# Run test suite
npx hardhat test

# Generate coverage report
npx hardhat coverage
```

## Performance Optimization

### Storage Efficiency
- Content deduplication
- Compression
- Smart replication
- Caching system

### Node Selection
- Geographic distribution
- Load balancing
- Performance metrics
- Cost optimization

## Future Enhancements
- Layer 2 scaling
- Advanced encryption
- Dynamic pricing
- Cross-chain storage

## License
MIT License

## Contributing
1. Code review
2. Security audit
3. Performance testing
4. Documentation

## Support
- Technical docs
- Node operator guide
- Developer forum
- Support channel
