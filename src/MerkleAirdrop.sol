// SPDX-License-Identifier:MIT
pragma solidity ^0.8.16;

import {IERC20,SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop{

    // This means we can call any functions on any variables of IERC20 types
    using SafeERC20 for IERC20;
    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();
    
    event Claim(address account, uint256 amount);

    address[] claimers;
    
    bytes32 private immutable merkleRoot;
    IERC20 private immutable airdropToken;

    mapping(address claimer => bool claimed) private s_hasClaimed; 

    constructor(bytes32 _merkleRoot, IERC20 token){
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
   

    function claim(address account, uint256 amount, bytes32[] calldata merkelProof) external{
        if(s_hasClaimed[account]){
            revert MerkleAirdrop__AlreadyClaimed();
        }


        //Here, we are encoding the account and amount together and then taking hash of them
        //Q. Why are we hashing twice and concatenating?
        //A. When we are using Merkle Proofs and Merkle Trees we want to hash it twice and this avoid collisions
        // So, if you have two inputs that produce the same hash then its a problem. So, if we are hashing twice we are avoiding 
        // the problem and this is known as `second pre-image` attack
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encodePacked(account,amount))));

        //Now, we have the hash of the leaf, now we can verify the proof
        
        if(!MerkleProof.verify(merkelProof,merkleRoot,leaf)){
            revert MerkleAirdrop__InvalidProof();
        }
        
        s_hasClaimed[account] = true;
        emit Claim(account,amount);
        airdropToken.safeTransfer(account,amount);

    }

    function getMerkleRoot() external view returns (bytes32){
        return merkleRoot;
    }

    function getAirdropToken() external view returns(){
        return airdropToken;
    }





}

