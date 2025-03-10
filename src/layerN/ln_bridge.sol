// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// fix this
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract LnBridge {
    // depoloy new tokens id they dont exis
    // update balances

    bytes public erc20BytecodeHash;

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
    event Deployed(address, uint256);

    mapping(address => mapping(address => uint256)) public balances;
    mapping(address => address) public tokens;

    constructor(bytes memory _erc20BytecodeHash) {
        erc20BytecodeHash = _erc20BytecodeHash;
    }

    function proccessDeposit(Action memory _deposit) public {
        require(_deposit.token != address(0), "Invalid input.");
        address addr = tokens[_deposit.token];
        if (addr == address(0)) {
            addr = _deploy(erc20BytecodeHash, _getsalt(_deposit.token));
            tokens[_deposit.token] = addr;
        }
        // add protocol specific erc20
        // IERC20(_deposit.token)._mint(msg.sender, _deposit.amount);
    }

    function requestWithdraw(Action memory _withdraw) public {
        require(_deposit.token != address(0), "Invalid input.");
        uint256 balance = balances[msg.sender][_withdraw.token];
        require(_withdraw.amount > 0 && balance >= _withdraw.amount, "Amount must be greater than 0");
        balances[msg.sender][_withdraw.token] -= _withdraw.amount;
    }

    // check helpr functions
    function _getsalt(address _token) internal returns (bytes32) {
        bytes32 identifier = keccak256(abi.encode(address(_token)));
        bytes32 salt = bytes32(uint256(uint160(msg.sender)));
        return keccak256(bytes.concat(identifier, salt));
    }

    function _deploy(bytes memory bytecode, bytes32 _salt) internal returns (address) {
        address addr;

        assembly {
            addr := create2(0, add(bytecode, 0x20), mload(bytecode), _salt)

            if iszero(extcodesize(addr)) { revert(0, 0) }
        }

        emit Deployed(addr, _salt);
        return addr;
    }
}
