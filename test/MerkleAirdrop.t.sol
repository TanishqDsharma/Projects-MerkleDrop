// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.16;

import {Test,console} from "../lib/forge-std/src/Test.sol";
import {console2} from "../lib/forge-std/src/console2.sol";

import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {Bonky} from "../src/BonkyToken.sol";

contract MerkleAirdropTest is Test{

MerkleAirdrop public merkleAirdrop;
Bonky public bonky;
address user;
uint256 userPrivKey;
uint256 AMOUNT_TO_COLLECT = 25 * 1e18;
uint256 AMOUNT_TO_SEND = AMOUNT_TO_COLLECT*4;


bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
bytes32 proofOne = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
bytes32 proofTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
bytes32[] proof = [proofOne, proofTwo];

    function setUp() external {
        bonky = new Bonky();
        merkleAirdrop = new MerkleAirdrop(ROOT,bonky);
        bonky.mint(bonky.owner(),AMOUNT_TO_SEND);
        bonky.transfer(address(merkleAirdrop),AMOUNT_TO_SEND);
        (user,userPrivKey) = makeAddrAndKey("user");


    }


  function testUsersCanClaim() public {
        uint256 startingBalance = bonky.balanceOf(user);
        vm.prank(user);
        merkleAirdrop.claim(user, AMOUNT_TO_COLLECT, proof);
        uint256 endingBalance = bonky.balanceOf(user);
        console.log("Ending balance: %d", endingBalance);
        assertEq(endingBalance - startingBalance, AMOUNT_TO_COLLECT);
    }
        
        


        
} 