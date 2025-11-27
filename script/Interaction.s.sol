// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {VRFCoordinatorV2_5Mock} from "chainlink-brownie-contracts/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() public returns (uint256, address) {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig
            .getConfigByChainId(block.chainid)
            .vrfCoordinator;

        (uint256 subId, ) = _createSubscription(vrfCoordinator);
        return (subId, vrfCoordinator);
    }

    function _createSubscription(
        address vrfCoordinator
    ) public returns (uint256, address) {
        console.log("Creating Subscription for Chain:", block.chainid);

        vm.startBroadcast();
        uint256 subId = VRFCoordinatorV2_5Mock(vrfCoordinator)
            .createSubscription();
        vm.stopBroadcast();

        console.log("Subscription created:", subId);
        return (subId, vrfCoordinator);
    }

    function run() public {
        createSubscriptionUsingConfig();
    }
}
