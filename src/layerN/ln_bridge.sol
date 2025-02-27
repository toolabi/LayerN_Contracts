// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract LnBridge {
// depoloy new tokens id they dont exis
// update balances

    enum ActionType {
        Deposit,
        Withdraw
    }

    struct Action {
        ActionType action;
        address token;
        uint256 amount;
    }

    event LogAction(Action);

    mapping(address => mapping(address => uint256)) public balances;
    mapping(address => address) public tokens;


    function deposit(Action memory _deposit) public {
        require(_deposit.token != address(0), "Invalid input.");
        address addr = tokens[_deposit.token];
        if (addr == address(0)){

        }else{

        }

    }


    function _getLnAddress(address _token) internal returns(address){
        bytes32 identifier = keccak256(abi.encode(address(_token)));
        bytes32 salt = bytes32(uint256(uint160(msg.sender)));
        bytes32 preimage =keccak256(bytes.concat(identifier, salt));
        return address(uint160(uint256(preimage)));
    }


    
}
