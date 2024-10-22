// SPDX-License-Identifier:MIT
pragma solidity ^0.8.16;

import {IERC20,SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract MerkleAirdrop is EIP712{

    // This means we can call any functions on any variables of IERC20 types
    using SafeERC20 for IERC20;
    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();
    error MerkleAirdrop__InvalidSignature();

    
    event Claim(address account, uint256 amount);

    address[] claimers;
    
    bytes32 private immutable merkleRoot;
    IERC20 private immutable airdropToken;

    mapping(address claimer => bool claimed) private s_hasClaimed; 

    bytes32 private constant  MESSAGE_TYPEHASH = keccak256("AirdropClaim(address account, uint256 amount)");

    struct airdropClaim{
        address account;
        uint256 amount;
    }

    constructor(bytes32 _merkleRoot, IERC20 token) EIP712("MerkleDrop",1){
        merkleRoot=_merkleRoot;
        airdropToken=token;
    }


    /**
     * 
     * @param account The account who wants to claim
     * @param amount The amount they want to claim
     * @param merkelProof Array of proofs, the intermediate hashes that are required in order to be able to calculate the root
     * 
     */
   

    function claim(address account, uint256 amount, bytes32[] calldata merkelProof,uint8 v, bytes32 r, bytes32 s) external{
        if(s_hasClaimed[account]){
            revert MerkleAirdrop__AlreadyClaimed();
        }

        //check the signature
        if(!_isValidSignature(account, getMessage(account,amount), v,r,s)){
            revert MerkleAirdrop__InvalidSignature();

        }

        //Here, we are encoding the account and amount together and then taking hash of them
        //Q. Why are we hashing twice and concatenating?
        //A. When we are using Merkle Proofs and Merkle Trees we want to hash it twice and this avoid collisions
        // So, if you have two inputs that produce the same hash then its a problem. So, if we are hashing twice we are avoiding 
        // the problem and this is known as `second pre-image` attack
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encodePacked(account,amount))));
        
        //Now, we have the hash of the leaf, now we can verify the proof
        
        if(MerkleProof.verify(merkelProof,merkleRoot,leaf)==false){
            revert MerkleAirdrop__InvalidProof();
        }
        
        s_hasClaimed[account] = true;
        emit Claim(account,amount);
        airdropToken.safeTransfer(account,amount);

    }

    function getMessage(address account, uint256 amount) public view returns(bytes32){
        return _hashTypedDataV4(keccak256(abi.encode(MESSAGE_TYPEHASH, airdropClaim({account:account,amount:amount}))));

    }

    function getMerkleRoot() external view returns (bytes32){
        return merkleRoot;
    }

    function getAirdropToken() external view returns(IERC20){
        return airdropToken;
    }

    function _isValidSignature(address account, bytes32 digest, uint8 v, bytes32 r, bytes32 s) internal view returns(bool){
        (address actualSigner,,)=ECDSA.tryRecover(digest,v,r,s);
        return actualSigner == account;
    }


}

