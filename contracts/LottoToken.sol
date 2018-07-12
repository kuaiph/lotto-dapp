pragma solidity ^0.4.24;

import './LottoGamePlay.sol';

contract LottoToken is LottoGamePlay {

    string public name = "Lotto Token";
    string public symbol = "LTT";
    uint8 public constant decimals = 18; //1 ether = 10**18 wei
    uint256 public constant INITIAL_SUPPLY = 21000000 * (10 ** uint256(decimals));

    constructor() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
        open();
    }
}