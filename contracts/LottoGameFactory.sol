pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import './LottoBaseToken.sol';

/**
*   @dev 로또 게임의 가격과 방식을 결정하여 생성하는 Factory contract 입니다.
*/
contract LottoGameFactory is LottoBaseToken {

    using SafeMath for uint256;

    uint constant endDay7 = 7 days;
    uint constant endDay30 = 30 days;
    enum State { Playing, End, Distribution }

    uint createGameLTTPrice = 100; //LTT to

    // 게임
    struct LottoGame {
        string name;  // 해당 게임의 이름을 정할수 있습니다.
        State state;
        address winner; //해당 게임의 승리자입니다.
        uint256 joinerCount;
        uint256 tokenTotalBalance; //해당 게임에 모인 당첨금입니다.
        uint gameEndTimeAt; //게임 종료 날짜입니다.
        uint createdTimeAt; //게임 생성 날짜입니다.
        //GameRole role; //게임의 룰입니다.
    }

    // 게임 방식
    /*struct GameRole {
        uint8 price; //비용
        byes type; //금액 지불 방식 (1명, 절반)
        uint maxUserCount //참여 최대 인원
    }*/

    mapping (uint => address) public lottoGameManager; //게임의 진행자
    LottoGame[] public lottoGames; //로또 게임

    //event LottoGameStatus(LottoGame game);

    /**
     *  @dev 새로운 게임을 생성합니다.
     *  @param _name 로또 게임의 이름
     */
    function createLottoGame(string _name) public returns (bool){
        require(createGameLTTPrice >= balances[msg.sender]);
        transfer(owner, createGameLTTPrice);
        _createLottoGame(_name, endDay7);
        return true;
    }


    /**
     *  @dev 새로운 게임을 생성합니다.
     *  @param _name 로또 게임의 이름
     *  @param _endtime 종료 날짜
     */
    function _createLottoGame(string _name, uint _endtime) private {
        uint gameId = lottoGames.push(LottoGame(_name, State.Playing, 0x0, 0, 0, now + _endtime, now));
        lottoGameManager[gameId] = msg.sender;

       // emit LottoGameStatus(lottoGames[gameId]);
    }
}
