pragma solidity ^0.8.0;

import "./lib/MiMC.sol";

contract Hasher {
    using MiMC for *;

    function getC() public pure returns (uint256[] memory) {
        return MiMC.getC();
    }

    function hash(uint256[] memory in_msgs) public pure returns (uint256) {
        return MiMC.Hash(in_msgs, 0, 91);
    }
}
