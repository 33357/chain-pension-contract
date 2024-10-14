// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract Persion {
    mapping(uint256 => Bill) public bills;
    uint256 public billIndex;

    uint256 immutable month = 30 days;

    event NewBill(address creater, uint256 billIndex);
    event CloseBill(uint256 billIndex);
    event ReceiveBill(uint256 billIndex);

    struct Bill {
        address owner;
        address payToken;
        uint256 payAmount;
        uint256 payMonths;
        uint256 receiveStartMonth;
        uint256 receiveMonths;
        uint256 payedMonths;
        uint256 receivedMonths;
        uint256 startTime;
        bool closed;
    }

    modifier _notClosed(uint256 _billIndex) {
        require(!bills[_billIndex].closed, "closed");
        _;
    }

    function createBill(
        address payToken,
        uint256 payAmount,
        uint256 payMonths,
        uint256 receiveStartMonth,
        uint256 receiveMonths
    ) external {
        bills[billIndex] = Bill(
            msg.sender,
            payToken,
            payAmount,
            payMonths,
            receiveStartMonth,
            receiveMonths,
            0,
            0,
            block.timestamp,
            false
        );
        emit NewBill(msg.sender, billIndex++);
    }

    function closeBill(uint256 _billIndex) external _notClosed(_billIndex) {
        Bill memory bill = bills[_billIndex];
        require(bill.owner == msg.sender, "not owner");
        bills[_billIndex].closed = true;
        _payOwner(_billIndex, bill.payMonths * bill.payAmount);
    }

    function payBill(
        uint256 _billIndex
    ) external payable _notClosed(_billIndex) {
        Bill memory bill = bills[_billIndex];
        require(
            block.timestamp - getNextPayTime(_billIndex) < month,
            "not pay time"
        );
        if (bill.payToken != address(0)) {
            IERC20(bill.payToken).transferFrom(
                msg.sender,
                address(this),
                bill.payAmount
            );
        } else {
            require(msg.value == bill.payAmount, "error amount");
        }
        bills[_billIndex].payedMonths += 1;
    }

    function receiveBill(uint256 _billIndex) external _notClosed(_billIndex) {
        Bill memory bill = bills[_billIndex];
        require(bill.payedMonths == bill.payMonths, "error payedMonths");
        require(
            block.timestamp >
                bill.startTime +
                    (bill.receiveMonths + bill.receivedMonths) *
                    month,
            "error time"
        );
        bills[_billIndex].receivedMonths += 1;
        _payOwner(
            _billIndex,
            (bill.payMonths * bill.payAmount) / bill.receiveMonths
        );
    }

    function getNextPayTime(uint256 _billIndex) public view returns (uint256) {
        Bill memory bill = bills[_billIndex];
        return bill.startTime + bill.payedMonths * month;
    }

    function _payOwner(uint256 _billIndex, uint256 amount) internal {
        Bill memory bill = bills[_billIndex];
        if (bill.payToken != address(0)) {
            IERC20(bill.payToken).transfer(bill.owner, amount);
        } else {
            payable(bill.owner).transfer(amount);
        }
    }
}
