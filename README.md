# Lotto DApp (Solidity Code) 
테스트용 로또 DApp입니다. ERC20 interface(feat.zeppelin-solidity) 를 상속 받아 로또에 참여하기 위한 기본 토큰을 구현하였습니다. 
추후 Lotto Token의 Crowdsale 컨트렉트, Lotto 게임의 가각 고유한 규칙과 특징을 유지할수 있는 ERC721을 구현하여 확장시킬 계획입니다.

![첨부이미지](https://github.com/sinsker/lotto-dapp/tree/master/app/image1.png)

<pre>
ㄴ sale
    LottoTokenSale.sol
Lotto.sol
LottoBaseToken.sol
LottoGameFactory.sol
LottoGamePlay.sol
LottoTokenConfig.sol
</pre>


### Init Project
1. testing (test path ./test)
<pre>
npm i -g truffle 
git clone git@github.com:sinsker/lotto-dapp.git
npm i --dev
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