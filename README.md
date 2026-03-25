# ZK-Shield Mixer

This repository provides a structural implementation of a privacy mixer. It uses **Merkle Trees** to manage "Commitments" (deposits) and **Nullifiers** to prevent double-spending during the "Withdrawal" phase.

## How it Works
1. **Deposit**: A user generates a secret `nullifier` and `secret`, hashes them together to create a `commitment`, and sends the asset + commitment to the contract.
2. **Commitment Tree**: The contract adds the commitment to an on-chain Merkle Tree.
3. **Withdrawal**: The user provides a ZK-Proof (simulated here via a cryptographic hash check) that they know a secret corresponding to a leaf in the tree, without revealing which leaf it is.

## Security Features
* **Linkability Protection**: Breaks the direct transaction history between the sender and receiver.
* **Merkle Proof Validation**: Ensures that only valid depositors can withdraw.
* **Nullifier Registry**: Prevents a single deposit from being withdrawn multiple times.

*Note: In a production environment, the withdrawal validation would be performed by a Circom/SnarkJS verifier contract.*
