// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {CreateSubscription} from "./Interaction.s.sol";

contract DeployRaffle is Script {
    function run() public {
        deployContract();
    }

    function deployContract()
        public
        returns (Raffle raffle, HelperConfig helperConfig)
    {
        helperConfig = new HelperConfig();

        HelperConfig.NetworkConfig memory config = helperConfig
            .getConfigByChainId(block.chainid);

        if (config.subscriptionId == 0) {
            CreateSubscription sub = new CreateSubscription();
            (config.subscriptionId, config.vrfCoordinator) = sub
                .createSubscriptionUsingConfig();
        }

        vm.startBroadcast();
        raffle = new Raffle(
            config.entranceFee,
            config.interval,
            config.vrfCoordinator,
            config.gasLane,
            config.subscriptionId,
            config.callbackGasLimit
        );
        vm.stopBroadcast();

        return (raffle, helperConfig);
    }
}
