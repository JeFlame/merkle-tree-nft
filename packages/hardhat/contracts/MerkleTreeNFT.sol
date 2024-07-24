// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { MerkleProof } from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleTreeNFT is ERC721 {
	bytes32 public immutable root; // Root of the Merkle tree
	mapping(address => bool) public mintedAddress; // Record the address that has already been minted

	constructor(bytes32 merkleroot) ERC721("MerkleTreeNFT", "MTNFT") {
		root = merkleroot;
	}

	// Use the Merkle tree to verify the address and mint
	function mint(
		address account, // 0xe84680C37f320c56d9F26E549155D33Bd412e7E3
		uint256 tokenId, // 0
		bytes32[] calldata proof // ["0x8005f298c588300b4afe5074bfa5a8db4bb9da3fb7c3dffd9f362a378247c91e", "0xe49302e900d94f5ceb35d432f94b58c1ffca5f19ba4f7021c94db778967cf175"]
	) external {
		require(_verify(_leaf(account), proof), "Invalid merkle proof"); // Merkle verification passed
		require(!mintedAddress[account], "Already minted!"); // Address has not been minted

		mintedAddress[account] = true; // Record the minted address
		_mint(account, tokenId); // Mint
	}

	// Calculate the hash value of the Merkle tree leaf
	function _leaf(address account) internal pure returns (bytes32) {
		return keccak256(abi.encodePacked(account));
	}

	// Merkle tree verification, call the verify() function of the MerkleProof library
	function _verify(
		bytes32 leaf,
		bytes32[] memory proof
	) internal view returns (bool) {
		return MerkleProof.verify(proof, root, leaf);
	}
}
