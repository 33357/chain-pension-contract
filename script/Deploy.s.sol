// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import { Persion } from "../src/Persion.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Persion p = new Persion();
        vm.stopBroadcast();
        writeToFile(address(p));
    }

    function writeToFile(address contractAddress) internal {
        string memory path = "./sdk/src/config/deployment.json";
        string memory content = string(abi.encodePacked('{"',vm.toString(block.chainid),'":{"Persion":{"proxyAddress":"',vm.toString(contractAddress),'","implAddress":"',vm.toString(contractAddress),'","operator":"',vm.toString(tx.origin),'","fromBlock":',vm.toString(block.number),'}}}'));
        vm.writeFile(path, content);
    }
}
