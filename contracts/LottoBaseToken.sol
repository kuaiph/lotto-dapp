pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import './LottoTokenConfig.sol';

contract LottoBaseToken is StandardToken, LottoTokenConfig, Ownable {

    bool private opened = false;

    constructor() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
        open();

        //EIP20
        emit Transfer(0x0, msg.sender, totalSupply_);
    }

    modifier onlyOpened() {
        require(opened);
        _;
    }

    function open() public onlyOwner {
        require(!opened);
        opened = true;
    }


    function close() public onlyOwner {
        require(opened);
        opened = false;
    }

    /**
    * override ERC20 function
    */
    function transfer(address to, uint256 value) public onlyOpened returns (bool) {
        super.transfer(to, value);
    }
    function allowance(address owner, address spender) public onlyOpened view returns (uint256) {
        super.allowance(owner,spender);
    }
    function transferFrom(address from, address to, uint256 value) public onlyOpened returns (bool) {
        super.transferFrom(from, to, value);
    }
    function approve(address spender, uint256 value) public onlyOpened returns (bool) {
        super.approve(spender,value);
    }


}
