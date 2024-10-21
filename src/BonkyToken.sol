// SPDX-License-Identifier:MIT
pragma solidity ^0.8.16;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


contract Bonky is ERC20,Ownable {

    constructor() ERC20("Bonky","BKY") Ownable(msg.sender){

    }

    function mint(address to,uint256 amount) external onlyOwner{
        _mint(to,amount);
    }   
}