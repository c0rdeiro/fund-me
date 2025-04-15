// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimunUsd = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= minimunUsd, "Did not send enough ETH."); //1 ETH
        
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;

    }

    function withdraw() public {
        require(msg.sender == owner, "Must be the owner of the contract");

        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex ++) {
            
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
            funders = new address[](0);

            (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
            require(callSuccess, "Withdraw failed.");
        }
    }

  
}