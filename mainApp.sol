//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceLogic} from "../library/priceLogic.sol";

error notOwner();
contract crowdFund{

    
    address public immutable i_owner;
    uint constant minimumDonation = 0;
    address[] public listOfFunders;
    mapping(address => uint256) public addressToAmountFunded;

    constructor(){
        i_owner = msg.sender;
    }


    function fund() payable public{
        require(msg.value >= minimumDonation, "not up to minimum donation");
        listOfFunders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

   

    function withdraw() public onlyOwner{

        for (uint eachFunder = 0; eachFunder < listOfFunders.length; eachFunder++){
            address funders = listOfFunders[eachFunder];
            addressToAmountFunded[funders] = 0;
        }

        listOfFunders = new address[](0);

        (bool callSuccess,) = payable(msg.sender).call{value:address(this).balance}("");
        require(callSuccess, "withdraw failed");
    }

    modifier onlyOwner(){
        if (msg.sender != i_owner){revert notOwner();}_; }

    //Integrating Dontions without using our Dapp.
    receive() external payable{fund() ;}

    fallback () external payable{fund();}
}

