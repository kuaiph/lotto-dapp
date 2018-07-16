pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import './Lotto.sol';

contract LottoTokenSale is Ownable {

    using SafeMath for uint256;

    event FundTransfer(address backer, uint amount);

    uint8 public constant decimals = 18; //1 ether = 10**18 wei
    uint public constant LTT_PER_WEI = 1 * (10 ** uint256(decimals)); // 1wei == 1LTT
    uint public constant HARD_CAP = 300000000;
    uint public lttTotalRaised = 0;
    bool private closed = false;
    ERC20 public token;

    constructor(address _token) public Ownable() {
        require(_token != address(0));
        token = ERC20(_token);
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

        owner.transfer(msg.value);
        token.transfer(msg.sender, lttToTransfer);

        emit FundTransfer(msg.sender, lttToTransfer);
    }

    function getTotalRaised() public view returns(uint) {
        return lttTotalRaised;
    }

}
