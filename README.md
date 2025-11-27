Raffle Lottery – Smart Contract (Foundry)

This project implements a decentralized automated raffle (lottery) system on Ethereum-compatible blockchains. The contract allows participants to enter by paying an entrance fee, and a winner is selected automatically at fixed time intervals using Chainlink VRF for secure randomness and Chainlink Automation for upkeep checks.

Key Features.

Automated winner selection using Chainlink Automation

Provably fair randomness through Chainlink VRF

Configurable entrance fee and time intervals

Secure design following best practices (checks-effects-interactions pattern, custom errors, events, etc.)

Fully testable using Foundry (unit tests + fuzz tests)

Modular script system for deployment, interactions, and configuration

Environment-aware configuration (local, testnet, mainnet)


Smart Contracts Overview.

Raffle.sol

Core lottery contract:

Allows players to enter the raffle

Tracks player list, entrance fee, and raffle state

Requests randomness and picks a winner

Automatically resets for the next round


HelperConfig.s.sol

Network configuration:

Stores settings (vrfCoordinator, subscriptionId, gasLane, callbackGasLimit, interval, etc.)

Provides different configs for local Anvil vs testnets


DeployRaffle.s.sol

Deployment script:

Deploys the Raffle contract

Sets correct configuration depending on the active network


Interaction.s.sol

Utility script:

Creates and funds VRF subscription

Adds Raffle contract as a VRF consumer

Manual triggers for keeper/check functions (for testing)


Tech Stack

Solidity 0.8.x

Foundry (forge, cast, anvil)

Chainlink VRF & Automation

OpenZeppelin Contracts


Testing

The project includes a complete Foundry test suite:

Unit tests for each function

Event testing

State transitions

Time-based behavior

VRF and Automation mock testing
