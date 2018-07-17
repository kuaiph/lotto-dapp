# Lotto DApp (Solidity Code) 
로또 게임 디앱 테스트 입니다. ERC20 interface(feat.zeppelin-solidity) 를 상속 받아 로또에 참여하기 위한 기본 토큰을 구현하였습니다. 
추후 Lotto Token의 Crowdsale 컨트렉트 Lotto 게임의 가각 고유한 게임을 유지할수 있는 ERC721을 구현하여 작성하 계획입니다.

<pre>
ㄴ sale
    LottoTokenSale.sol
Lotto.sol
LottoBaseToken.sol
LottoGameFactory.sol
LottoGamePlay.sol
LottoTokenConfig.sol
</pre>

### solidity build
1. testing (test path ./test)
<pre>
truffle test
</pre>

2. build (output path ./build)
<pre>
truffle compile
</pre>


3. deploy (dependency options trffle.js)
<pre>
truffle migrate --reset --network development
truffle migrate --reset --network testnet
</pre>
    
 ### app webpack build
1. webpack dev 
<pre>
npm run dev //webpack-dev-server --hot
</pre>

2. webpack build
<pre>
npm run build //webpack
</pre>