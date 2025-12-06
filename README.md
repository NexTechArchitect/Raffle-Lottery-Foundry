Raffle Lottery – Decentralized Automated Raffle (Foundry)

This repository contains an automated decentralized lottery (raffle) smart contract built with Solidity and Foundry. The system enables participants to enter by paying an entrance fee, and automatically selects and rewards a winner at predefined intervals. Winner selection is powered by Chainlink VRF for verifiable randomness, and uptime reliability is achieved using Chainlink Automation.

The project emphasizes correctness, security, testability, modularity, maintainability, and environment-aware deployments.

Architectural Overview

The contract suite integrates:

User Interaction Layer

Users enter the raffle by paying the configured entrance fee.

Entries are recorded securely until the next winner is drawn.

Automation Layer

Chainlink Automation regularly calls upkeep to determine if a draw must occur.

The contract autonomously transitions between entry and draw phases.

Randomness Layer

Chainlink VRF provides unbiased randomness.

Randomness is external, verifiable, and non-manipulable.

Lifecycle Management

After winner selection, the raffle resets and becomes ready for the next round.

Contract states ensure there is never overlap between drawing and entering.

Key Features

Automated winner selection through Chainlink Automation

Cryptographically secure winner randomness via Chainlink VRF

State machine architecture to prevent inconsistent transitions

Configurable parameters (entrance fee, time interval, callback gas limits, etc.)

Deployment and maintenance scripts supporting multiple networks

Comprehensive Foundry test suite covering edge cases and invariants

Event-driven transparency for external observers or indexing

Uses recommended Solidity defensive programming patterns

Compatible with Ethereum, L2s, and local development environments

Smart Contract Modules
1. Raffle.sol

Core raffle logic:

Stores participant list

Accepts entries by enforcing entrance fee

Tracks raffle state (OPEN, CALCULATING)

Runs periodic checks and automated state transitions

Requests randomness from VRF and selects a winner

Emits events for indexing or off-chain analytics

2. HelperConfig.s.sol

Network configuration abstraction:

Provides network-specific configuration parameters

Enables uniform deployment logic across Anvil, Sepolia, Mainnet, etc.

Centralizes coordinator addresses, subscription IDs, gas lanes, and callback limits

3. DeployRaffle.s.sol

Deployment entrypoint:

Deploys the Raffle contract with settings derived from HelperConfig

Prevents hardcoded values and minimizes deployment errors

4. Interaction.s.sol

Automation and VRF subscription utility:

Creates and funds VRF subscription on supported networks

Registers Raffle as VRF consumer

Provides manual upkeep/fulfillment triggers for local or test simulations

Security Considerations

Follows Checks-Effects-Interactions (CEI) pattern

Uses custom errors for gas-efficient revert reasons

Ensures state transitions are atomic, preventing re-entry into inconsistent phases

Avoids storage manipulation during draw execution

Leverages Chainlink infrastructure to eliminate randomness manipulation

Event logging provides clear traceability for auditability

Testing Approach

A full Foundry test suite is provided, including:

Unit tests for core functions

State transition tests across all raffle phases

VRF randomness simulation using mocks

Automation upkeep condition tests

Fuzz testing for edge behaviors

Event emission validation

Comprehensive assertions on invariants

Tests ensure behavioral correctness across local and remote environments.

Tooling and Dependencies

Solidity ^0.8.x

Foundry (forge, cast, anvil)

Chainlink VRF v2 and Automation

OpenZeppelin utilities

Custom deployment and maintenance scripts

Development Workflow

Configure environment using HelperConfig.s.sol

Deploy with DeployRaffle.s.sol

Create and register VRF subscription (if on a live testnet or mainnet)

Execute upkeep (local manual simulation or automated on live networks)

Interact via Foundry scripts, cast, or external UI

Use Cases

Fair lotteries

Weekly prize draws

Raffle-based NFT mints

Ticket-based selection mechanisms

DAO reward distribution

Community incentive systems

License

MIT License

Author

NexTechArchitect
Smart Contract Development, Solidity, Foundry, Web3 Engineering
