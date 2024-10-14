//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceLogic} from "../library/priceLogic.sol";

error notOwner();
contract crowdFund{

    address public immutable i_owner;
    uint constant minimumDonation = 1e17; 
    address[] public listOfFunders; //lst of Donors
    mapping(address => uint256) public addressToAmountFunded; //mapping amount donated to EVM address

    constructor(){
        i_owner = msg.sender; //Setting an initial wallet that has access to the withdraw function
        
    }


    function fund() payable public{
        require(PriceLogic.ConvertWeiToUSD(msg.value) >= minimumDonation, "not up to minimum donation");
        listOfFunders.push(msg.sender); //Adds a donor to the list
        addressToAmountFunded[msg.sender] += msg.value; //updates the amount donated by an address
    }

   

    function withdraw() public onlyOwner{  

        //this loop resets every donation made by any wallet to zero
        for (uint eachFunder = 0; eachFunder < listOfFunders.length; eachFunder++){
            address funders = listOfFunders[eachFunder];
            addressToAmountFunded[funders] = 0;
        }

        //This line resets the array of addresses
        listOfFunders = new address[](0);

        // This is a call method to withdraw funds and to reset the balance on the contract
        (bool callSuccess,) = payable(msg.sender).call{value:address(this).balance}("");
        require(callSuccess, "withdraw failed");
    }

    //checker to make sure inital address on deploying contract passes.
    modifier onlyOwner(){  
        if (msg.sender != i_owner){revert notOwner();}_; }

    //Integrating Dontions without using our Dapp.
    receive() external payable{fund() ;}

    fallback () external payable{fund();}
}

