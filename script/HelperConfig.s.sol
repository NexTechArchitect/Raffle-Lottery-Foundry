// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {VRFCoordinatorV2_5Mock} from "chainlink-brownie-contracts/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

abstract contract CodeConstants {
    // Mock values for local chain
    uint96 public constant MOCK_BASE_FEE = 0.1 ether;
    uint96 public constant MOCK_GAS_PRICE_LINK = 1e9;
    int256 public constant MOCK_WEI_PER_LINK = 1e15; // random value, acceptable for mocks

    uint256 public constant LOCAL_CHAIN_ID = 31337;

    // Sepolia
    uint256 public constant SEPOLIA_CHAIN_ID = 11155111;
}

contract HelperConfig is CodeConstants, Script {
    error HelperConfig_InvalidChainId();

    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLane;
        uint256 subscriptionId;
        uint32 callbackGasLimit;
    }

    mapping(uint256 => NetworkConfig) public chainIdToNetworkConfig;

    constructor() {
        chainIdToNetworkConfig[SEPOLIA_CHAIN_ID] = getSepoliaEthConfig();
        chainIdToNetworkConfig[LOCAL_CHAIN_ID] = getOrCreateAnvilEthConfig();
    }

    function getConfigByChainId(
        uint256 chainId
    ) public view returns (NetworkConfig memory) {
        NetworkConfig memory config = chainIdToNetworkConfig[chainId];
        if (config.vrfCoordinator == address(0))
            revert HelperConfig_InvalidChainId();
        return config;
    }

    // ------------------------------
    //  CONFIG FOR SEPOLIA
    // ------------------------------
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                entranceFee: 0.01 ether,
                interval: 30,
                vrfCoordinator: 0x8103b0a8a00be2dDC778E6e7eAA3c2a56761f4c0,
                gasLane: 0x474e34a077df13bde3e0b3e3c9a1d83bde3d62b72d2faacb0d5b9ee9554eb2d3,
                subscriptionId: 0,
                callbackGasLimit: 500000
            });
    }

    // ------------------------------
    //  LOCAL ANVIL + MOCK CONFIG
    // ------------------------------
    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // Already exists → return it
        if (
            chainIdToNetworkConfig[LOCAL_CHAIN_ID].vrfCoordinator != address(0)
        ) {
            return chainIdToNetworkConfig[LOCAL_CHAIN_ID];
        }

        vm.startBroadcast();

        VRFCoordinatorV2_5Mock vrfMock = new VRFCoordinatorV2_5Mock(
            MOCK_BASE_FEE,
            MOCK_GAS_PRICE_LINK,
            MOCK_WEI_PER_LINK
        );

        vm.stopBroadcast();

        return
            NetworkConfig({
                entranceFee: 0.01 ether,
                interval: 30,
                vrfCoordinator: address(vrfMock),
                gasLane: bytes32(0),
                subscriptionId: 0,
                callbackGasLimit: 500000
            });
    }
}
