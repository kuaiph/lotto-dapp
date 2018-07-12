pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import './LottoToken.sol';

contract LottoTokenSale {

    using SafeMath for uint256;

    uint8 public constant decimals = 18; //1 ether = 10**18 wei
    uint public constant LTT_PER_WEI = 1 * (10 ** uint256(decimals)); // 1wei == 1LTT
    uint public constant HARD_CAP = 300000000;

    uint public lttTotalRaised = 0;

    bool private closed = false;

    LottoToken public token;

    constructor(LottoToken _token) public {
        require(_token != address(0));
        token = _token;
    }

    function() external payable {
        require(!closed);
        require(msg.value != 0);

        uint lttToTransfer = msg.value.mul(LTT_PER_WEI);
        uint weisToRefund = 0;

        if (lttTotalRaised + lttToTransfer > HARD_CAP) {
            lttToTransfer = HARD_CAP - lttTotalRaised;
            weisToRefund = msg.value - lttToTransfer.div(LTT_PER_WEI);
            closed = true;
        }
        lttTotalRaised = lttTotalRaised.add(lttToTransfer);

        if (weisToRefund > 0) {
            msg.sender.transfer(weisToRefund);
        }

        token.transfer(msg.sender, lttToTransfer);
    }

}
