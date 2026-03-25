const { ethers } = require("ethers");
const { MerkleTree } = require("fixed-merkle-tree");

// Utility to generate a commitment off-chain
function generateCommitment() {
    const nullifier = ethers.randomBytes(31);
    const secret = ethers.randomBytes(31);
    
    const commitment = ethers.keccak256(
        ethers.concat([nullifier, secret])
    );

    const nullifierHash = ethers.keccak256(nullifier);

    return {
        nullifier,
        secret,
        commitment,
        nullifierHash
    };
}

module.exports = { generateCommitment };
