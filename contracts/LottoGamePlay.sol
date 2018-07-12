pragma solidity ^0.4.24;

import './LottoGameFactory.sol';

/**
*   @dev 로또 게임의 가격과 방식을 결정하여 생성하는 Factory contract 입니다.
*/
contract LottoGamePlay is LottoGameFactory {

    //게임 참가 지불 금액
    uint playGameDefaultBalances = 50;

    //유저의 게임 참여 번호
    mapping (uint256 => mapping (address => uint256)) public lottoGameJoinTicket;

    event gameJoinEvent(address _joiner, uint256 _value, uint256 _gameId);
    event gameEndEvent(address _winner, uint256 _getTotalBalance);


    //게임 존재 여부
    modifier isExistenceByGame(uint256 _gameId){
        //require(lottoGames[_gameId]);
        _;
    }

    //게임 상태 체크
    modifier gameStateCheck(uint256 _gameId) {
        require(lottoGames[_gameId].state == State.Playing);
        _gameTimeEnd(_gameId);
        _;
    }

    /**
     *  @dev 게임에 가입합니다.
     */
    function gameJoin(uint256 _gameId) isExistenceByGame(_gameId) gameStateCheck(_gameId) public {
        require(playGameDefaultBalances <= balances[msg.sender]);

        LottoGame storage game = lottoGames[_gameId];

        // 1. 유저의 게임참가비만큼 토큰을 감소시킨다.
        // 2. 유저의 게임참가비를 게임의 총 토큰으로 증가시킨다.
        balances[msg.sender].sub(playGameDefaultBalances);
        game.tokenTotalBalance.add(playGameDefaultBalances);
        // 3. 게임에 유저를 등록한다.
        // 4. 유저에게 게임 참가 티켓을 발급시켜준다.
        // 5. 게임에 총 참가자 수를 1 증가시킨다.
        lottoGameJoinTicket[_gameId][msg.sender] = playGameDefaultBalances;
        game.joinerCount.add(1);
        emit gameJoinEvent(msg.sender, playGameDefaultBalances, _gameId);
    }

    /**
     *  @dev 게임 운영자가 강제 종료합니다.
     *  @param _gameId 종료 날짜
     */
    function gameForceEnd(uint256 _gameId) public isExistenceByGame(_gameId) {
        require(msg.sender == lottoGameManager[_gameId]);
        _gameStateEndChange(_gameId);
    }


    function gameWinnerAnnouncement(uint256 _gameId) public view{
        require(lottoGames[_gameId].state == State.End);

    }

    function _gameTimeEnd(uint256 _gameId) private {
        if(now <= lottoGames[_gameId].gameEndTimeAt){
            _gameStateEndChange(_gameId);
        }
    }

    function _gameStateEndChange(uint256 _gameId) private {
        lottoGames[_gameId].state = State.End;
    }
}
