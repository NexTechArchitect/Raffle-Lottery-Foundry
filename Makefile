.PHONY: all build test clean snapshot format anvil deploy

all: build

build:
	forge build

test:
	forge test -vvv

clean:
	forge clean

snapshot:
	forge snapshot

format:
	forge fmt

anvil:
	anvil

deploy:
	forge script script/DeployRaffle.s.sol