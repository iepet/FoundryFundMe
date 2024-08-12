//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from  "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;
    uint256 public constant SEND_VALUE = 0.5 ether; // just a value to make sure we are sending enough!
    uint256 public constant STARTING_USER_BALANCE = 10 ether;
    uint256 public constant GAS_PRICE = 1;
    address public  USER = makeAddr("user");

    function setUp() external {
        console.log("testing sadfafdsasf hello");
        console.log("Deployed FundMe address:", address(fundMe));
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER,STARTING_USER_BALANCE);
    }

    function testUserCanFundInteractions() public { 
        FundFundMe  fundFundMe = new FundFundMe();
        vm.prank(USER);
        vm.deal(USER,1e18);
        fundFundMe.fundFundMe(address(fundMe));

        address funder = fundMe.getFunder(0);
        assertEq(funder,USER);
    }

    function testUserCanWithdrawInteractions() public {
        FundFundMe  fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));
        
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance ==0);
    }
}