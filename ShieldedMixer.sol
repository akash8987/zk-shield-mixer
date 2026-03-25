// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ShieldedMixer is ReentrancyGuard, Ownable {
    uint256 public constant DENOMINATION = 1 ether;
    uint32 public constant MERKLE_TREE_HEIGHT = 20;

    mapping(bytes32 => bool) public nullifiers;
    mapping(bytes32 => bool) public commitments;
    
    // Simplification: In production, use an incremental Merkle Tree contract
    bytes32[] public leaves;

    event Deposit(bytes32 indexed commitment, uint32 leafIndex, uint256 timestamp);
    event Withdrawal(address to, bytes32 nullifierHash);

    constructor() Ownable(msg.sender) {}

    /**
     * @dev Deposit 1 ETH into the mixer with a commitment.
     */
    function deposit(bytes32 _commitment) external payable nonReentrant {
        require(msg.value == DENOMINATION, "Please send exactly 1 ETH");
        require(!commitments[_commitment], "Commitment already exists");

        commitments[_commitment] = true;
        leaves.push(_commitment);

        emit Deposit(_commitment, uint32(leaves.length - 1), block.timestamp);
    }

    /**
     * @dev Withdraw from the mixer using a proof of knowledge.
     * @param _nullifierHash The hash of the secret nullifier to prevent double-spending.
     * @param _root The Merkle Root the user is proving membership against.
     * @param _recipient The address to receive the funds.
     */
    function withdraw(
        bytes32 _nullifierHash,
        bytes32 _root,
        address payable _recipient
    ) external nonReentrant {
        require(!nullifiers[_nullifierHash], "Proof has already been used");
        
        // In a real ZK-Mixer, we would call an IVerifier(verifier).verifyProof(...) here.
        // For this PoC, we assume the off-chain relayer/user provides a valid proof.
        // require(verifier.verifyProof(proof, [...]), "Invalid ZK Proof");

        nullifiers[_nullifierHash] = true;
        
        (bool success, ) = _recipient.call{value: DENOMINATION}("");
        require(success, "Payment failed");

        emit Withdrawal(_recipient, _nullifierHash);
    }
}
