// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    uint256 public minimunUsd = 5e18;

    function fund() public payable {
        require(getConversionRate(msg.value) >= minimunUsd, "Did not send enough ETH."); //1 ETH

    }

    // function withdraw() public {}

    function getPrice() public view returns(uint256){
        //0x694AA1769357215DE4FAC081bf1f309aDC325306 ETH/USDC chainlink sepolia
        AggregatorV3Interface priceFeed =  AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 price,, ,) = priceFeed.latestRoundData();

        return uint256(price * 1e10);

    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount)/1e18;
        return ethAmountInUsd;
    }
}