// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract YakuzaKumiai is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("YakuzaKumiai", "NFT") {}

    function mintNFT(address recipient, string memory tokenURI)
        public onlyOwner
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    // --- PROPERTIES ---- //

    // Calculated from `merkletree.js`
    bytes32 public merkleRoot =
        0x39a01635c6a38f8beb0adde454f205fffbb2157797bf1980f8f93a5f70c9f8e6;

    mapping(address => bool) public whitelistClaimed;

    // --- FUNCTIONS ---- //

    function whitelistMint(bytes32[] calldata _merkleProof) public {
        require(!whitelistClaimed[msg.sender], "Address already claimed");
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProof.verify(_merkleProof, merkleRoot, leaf),
            "Invalid Merkle Proof."
        );
        whitelistClaimed[msg.sender] = true;
    }
}


