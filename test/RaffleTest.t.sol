// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Raffle} from "src/Raffle.sol";
import {DeployRaffle} from "script/DeployRaffle.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {Test} from "forge-std/Test.sol";
import {VRFCoordinatorV2_5Mock} from "chainlink-brownie-contracts/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

contract RaffleTest is Test {
    Raffle public raffle;
    HelperConfig public helperConfig;

    uint256 entranceFee;
    uint256 interval;
    address vrfCoordinator;
    bytes32 gasLane;
    uint256 subscriptionId;
    uint32 callbackGasLimit;

    /**Events */
    event RaffleEntered(address indexed player);
    event WinnerPicked(address indexed winner);

    address public PLAYER = makeAddr("player");
    uint256 public constant STARTING_PLAYER_BALANCE = 10 ether;

    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.deployContract();

        HelperConfig.NetworkConfig memory config = helperConfig
            .getConfigByChainId(block.chainid);

        entranceFee = config.entranceFee;
        interval = config.interval;
        vrfCoordinator = config.vrfCoordinator;
        gasLane = config.gasLane;
        subscriptionId = config.subscriptionId;
        callbackGasLimit = config.callbackGasLimit;

        vm.deal(PLAYER, STARTING_PLAYER_BALANCE);
    }

    function testRaffleInitialization() external view {
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }

    function testRaffleRevertWhenYouDontPayEnough() public {
        vm.prank(PLAYER);
        vm.expectRevert(Raffle.Raffle_SendMoreToEnterRaffle.selector);
        raffle.enterRaffle();
    }

    function testRaffleRecordWhenSomeoneEnter() public {
        //arrange
        vm.prank(PLAYER);
        //act
        raffle.enterRaffle{value: entranceFee}();
        //assert
        address PlayerRecorded = raffle.getPlayer(0);
        assert(PlayerRecorded == PLAYER);
    }

    function test_enterRaffleEventEmits() public {
        // arrange
        vm.prank(PLAYER);

        // assert
        vm.expectEmit(true, false, false, false);
        emit RaffleEntered(PLAYER);

        // act
        raffle.enterRaffle{value: entranceFee}();
    }

    /*/////////////////////////////////////////////////////////
                       CHECKUP KEEP
////////////////////////////////////////////////////////*/

    function testCheckUpKeepReturnsFalseIfItHasNoBalance() public {
        // Arrange
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);

        //Act
        (bool upKeepNeeded, ) = raffle.checkUpKeep("");

        //assert
        assert(!upKeepNeeded);
    }
}
