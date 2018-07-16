pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import './LottoBaseToken.sol';

/**
*   @dev 로또 게임의 가격과 방식을 결정하여 생성하는 Factory contract 입니다.
*/
contract LottoGameFactory is LottoBaseToken {


    using SafeMath for uint256;

    event createLotto(uint gameIndex, address creator, string gameName, uint createTime, uint endTime);

    uint constant endDay7 = 7 days;
    uint constant endDay30 = 30 days;
    enum State { Playing, End, Distribution }

    uint createGameLTTPrice = 100; //LTT 게임 생성시 필요 코인 양

    // 게임
    struct LottoGame {
        string name;  // 해당 게임의 이름을 정할수 있습니다.
        State state;
        address winner; //해당 게임의 승리자입니다.
        uint256 joinerCount;
        uint256 tokenTotalBalance; //해당 게임에 모인 당첨금입니다.
        uint createdTimeAt; //게임 생성 날짜입니다.
        uint gameEndTimeAt; //게임 종료 날짜입니다.
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
    function createLottoGame(string _name) public returns (uint){
        require(createGameLTTPrice >= balances[msg.sender]);
        transfer(owner, createGameLTTPrice);
        return _createLottoGame(_name, endDay7);
    }

    /**
     *  @dev 게임의 상세 정보를 가져옵니다.
     *  @param _gameId 로또 게임의 번호
     */
    function detailGameOf(uint _gameId) public view
        returns(
            string,
            State,
            address,
            uint256 ,
            uint256 ) {

        LottoGame memory game = lottoGames[_gameId];

        return (game.name, game.state, game.winner, game.joinerCount, game.tokenTotalBalance);
    }

    /**
     *  @dev 새로운 게임을 생성합니다.
     *  @param _name 로또 게임의 이름
     *  @param _endtime 종료 날짜
     */
    function _createLottoGame(string _name, uint _endtime) private returns(uint){
        uint gameId = lottoGames.push(LottoGame(_name, State.Playing, 0x0, 0, 0, now + _endtime, now));
        lottoGameManager[gameId] = msg.sender;
        emit createLotto(gameId, msg.sender, _name, now, now + _endtime);

        return gameId;
    }
}
