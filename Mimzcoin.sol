// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// عملة تجريبية: للاستخدام على شبكات الاختبار (Sepolia) فقط
contract Mimzcoin is ERC20 {
    constructor() ERC20("Mimzcoin", "MIMZ") {
        // يُصدر 1,000,000 عملة لمن ينشر العقد (محفظتك التجريبية)
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
    }
}
