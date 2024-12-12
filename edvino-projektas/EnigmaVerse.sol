// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

// Interface for the standard BEP-20 token functions.
interface IBEP20 {
    // Events to log token transfer and approval actions.
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Functions to read token data.
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);

    // Functions to write token data.
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// Extended interface for BEP-20 tokens with metadata methods.
interface IBEP20Metadata is IBEP20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

// Provides methods to retrieve the sender of the message and the data in the call.
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// Contract module to define ownership and authorization mechanisms.
abstract contract Ownable is Context {
    address private _owner;

    // Custom error handling.
    error OwnableUnauthorizedAccount(address account);
    error OwnableInvalidOwner(address owner);

    // Event to log ownership transfer.
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // Constructor to set the initial owner.
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    // Modifier to restrict functions to the owner.
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    // Read owner address.
    function owner() public view virtual returns (address) {
        return _owner;
    }

    // Internal function to check if the caller is the owner.
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    // Public function to renounce ownership.
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    // Public function to transfer ownership.
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    // Internal function to handle ownership transfer.
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// Interface for custom errors specific to BEP-20 tokens.
interface IBEP20Errors {
    // Custom errors for various failure scenarios in token operations.
    error BEP20InsufficientBalance(address sender, uint256 balance, uint256 needed);
    error BEP20InvalidSender(address sender);
    error BEP20InvalidReceiver(address receiver);
    error BEP20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);
    error BEP20InvalidApprover(address approver);
    error BEP20InvalidSpender(address spender);
}

// BEP20 token implementation with standard functionalities.
abstract contract BEP20 is Context, IBEP20, IBEP20Metadata, IBEP20Errors {
    // Internal storage for token balances and allowances.
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // Total supply of the token.
    uint256 private _totalSupply;

    // Token metadata: name and symbol.
    string private _name;
    string private _symbol;

    // Constructor to set token metadata.
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    // Standard BEP-20 functions implementation.
    function name() public view virtual returns (string memory) { return _name; }
    function symbol() public view virtual returns (string memory) { return _symbol; }
    function decimals() public view virtual returns (uint8) { return 20; }
    function totalSupply() public view virtual returns (uint256) { return _totalSupply; }
    function balanceOf(address account) public view virtual returns (uint256) { return _balances[account]; }
    function transfer(address to, uint256 value) public virtual returns (bool) {
        _transfer(_msgSender(), to, value);
        return true;
    }
    function allowance(address owner, address spender) public view virtual returns (uint256) { return _allowances[owner][spender]; }
    function approve(address spender, uint256 value) public virtual returns (bool) {
        _approve(_msgSender(), spender, value);
        return true;
    }
    function transferFrom(address from, address to, uint256 value) public virtual returns (bool) {
        _spendAllowance(from, _msgSender(), value);
        _transfer(from, to, value);
        return true;
    }

    // Internal functions for token transfer and allowance handling.
    function _transfer(address from, address to, uint256 value) internal {
        // Custom error handling for invalid sender or receiver.
        if (from == address(0)) { revert BEP20InvalidSender(address(0)); }
        if (to == address(0)) { revert BEP20InvalidReceiver(address(0)); }
        _update(from, to, value);
    }
    function _update(address from, address to, uint256 value) internal virtual {
        // Handle balance update and total supply adjustments.
        // Emit Transfer event after successful update.
    }
    function _mint(address account, uint256 value) internal {
        // Handle token minting.
    }
    function _burn(address account, uint256 value) internal {
        // Handle token burning.
    }
    function _approve(address owner, address spender, uint256 value) internal {
        // Handle token allowance approval.
    }
    function _spendAllowance(address owner, address spender, uint256 value) internal virtual {
        // Handle the spending of allowances.
    }
}

// EnigmaVerseToken contract inheriting BEP20 and Ownable.
// Provides initial token supply and sets the contract owner.
contract EnigmaVerseToken is BEP20, Ownable {
    constructor(address initialOwner)
        BEP20("EnigmaVerse", "ENV")
        Ownable(initialOwner)
    {
        _mint(owner(), 100000e20); // Mint an initial supply to the owner.
    }
}
