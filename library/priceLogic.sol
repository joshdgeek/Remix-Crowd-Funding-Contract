//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceLogic{
     function getPrice() internal view returns(uint){
        //the price feed address passed here is for polygon-amoy testnet
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xF0d50568e3A7e8259E16663972b11910F89BD8e7);
        (, int Answer,,,) = priceFeed.latestRoundData();
        return uint (Answer*1e10);
    }

    function ConvertWeiToUSD(uint amount) internal view returns(uint) {
        uint priceOfToken = getPrice();
        uint priceInUsd = (priceOfToken * amount)/1e18;
        return priceInUsd;
    }
}