// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.13;


contract L1Bridge {
    address public l2Bridge;

    function setL2Bridge(address _l2Bridge) public {
        l2Bridge = _l2Bridge;
    }

    function deposit(address _token, uint256 _amount) public {
        require(_amount > 0, "Amount must be greater than 0");
    }
}