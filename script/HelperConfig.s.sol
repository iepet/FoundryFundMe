//SPDX-License-Identifier: MIT

//1. Deplpoy mocks for when we are in anvil local chains
//2. Keep track of different address accross diferent chains

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    //If we are on local anvil  we deploy mocks
    //otherwise  grab existing address from live network
    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE=2000e8;

    constructor (){
        if (block.chainid == 11155111){
            activeNetworkConfig = getSepoliaEthConfig();
        }else{
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }  
    
    struct NetworkConfig {
        address priceFeed;
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory){
        //price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306   
        });
        return sepoliaConfig;         
    }

    function getOrCreateAnvilEthConfig()  public returns(NetworkConfig memory) {
        
        //In order to save gas, we ask first if we have already set a price feed as default, if we have no need to run the rest
        if (activeNetworkConfig.priceFeed != address(0)){
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig ({
            priceFeed: address(mockPriceFeed)
        });

        return anvilConfig;
    }

}