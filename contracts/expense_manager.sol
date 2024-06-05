// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ExpenseManagerContract {
    address public owner;
    transaction[] public transactions;
    mapping(address => uint) public balances;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    struct transaction {
        address user;
        uint amount;
        string description;
        uint timestamp;
        bool isWithdraw;
    }

    event Deposit(
        address indexed _from,
        uint _value,
        string _description,
        uint _timestamp,
        bool isWithdraw
    );
    event Withdraw(
        address indexed _from,
        uint _value,
        string _description,
        uint _timestamp,
        bool isWithdraw
    );

    function depositAmount(
        uint _amount,
        string memory _description
    ) public payable {
        require(_amount > 0, "Amount should be greater than 0");
        balances[msg.sender] += _amount;
        transactions.push(
            transaction({
                user: msg.sender,
                amount: _amount,
                description: _description,
                timestamp: block.timestamp,
                isWithdraw: false
            })
        );
        emit Deposit(
            msg.sender,
            msg.value,
            _description,
            block.timestamp,
            false
        );
    }
    function getBalance(address _account) public view returns (uint) {
        return balances[_account];
    }
    function withdrawAmount(
        uint _amount,
        string memory _description
    ) public payable {
        require(_amount > 0, "Amount should be greater than 0");
        require(_amount <= balances[msg.sender], "Insufficient balance");
        require(
            _amount <= address(this).balance,
            "Contract doesn't have enough funds"
        );

        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);

        transactions.push(
            transaction({
                user: msg.sender,
                amount: _amount,
                description: _description,
                timestamp: block.timestamp,
                isWithdraw: true
            })
        );
        emit Withdraw(msg.sender, _amount, _description, block.timestamp, true);
    }

    function getAllTransactions()
        public
        view
        returns (
            address[] memory,
            uint[] memory,
            string[] memory,
            uint[] memory,
            bool[] memory
        )
    {
        address[] memory users = new address[](transactions.length);
        uint[] memory amounts = new uint[](transactions.length);
        string[] memory descriptions = new string[](transactions.length);
        uint[] memory timestamps = new uint[](transactions.length);
        bool[] memory isWithdraws = new bool[](transactions.length);

        for (uint i = 0; i < transactions.length; i++) {
            users[i] = transactions[i].user;
            amounts[i] = transactions[i].amount;
            descriptions[i] = transactions[i].description;
            timestamps[i] = transactions[i].timestamp;
            isWithdraws[i] = transactions[i].isWithdraw;
        }

        return (users, amounts, descriptions, timestamps, isWithdraws);
    }

    function getTransaction(
        uint _index
    )
        public
        view
        returns (
            address user,
            uint amount,
            string memory description,
            uint timestamp,
            bool isWithdraw
        )
    {
        require(_index < transactions.length, "Invalid index");
        transaction memory _transaction = transactions[_index];
        return (
            _transaction.user,
            _transaction.amount,
            _transaction.description,
            _transaction.timestamp,
            _transaction.isWithdraw
        );
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }
}
