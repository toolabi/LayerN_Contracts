// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";




contract L1Bridge {
    address public lnBridge;

    enum ActionType {
        Deposit,
        Withdraw
    }

    struct Action{
        ActionType action;
        address token;
        uint256 amount;
    }

    event LogAction(Action);


    mapping (address => Action) public deposits;

    constructor(address _lnBridge){
        require(_lnBridge != address(0), "Invalid address.");
        lnBridge = _lnBridge;
    }

    function deposit(Action memory _deposit) public {
        require(_deposit.amount > 0, "Amount must be greater than 0");

        SafeERC20.safeTransferFrom(IERC20(_deposit.token), msg.sender, address(this), _deposit.amount);
        emit LogAction(_deposit);
    }


}