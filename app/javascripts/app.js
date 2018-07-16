import "../stylesheets/app.css";

import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

import lottotoken_artifacts from '../../build/contracts/Lotto.json'
//import lottosale_artifacts from '../../build/contracts/LottoTokenSale.json'

const LottoToken = contract(lottotoken_artifacts);

let accounts;
let account;
let networkId;
let ltt;

window.App = {
  start: function() {
    let self = this;

    // 해당 컨트렉트를 통신할  provider를 연결합니다.
    LottoToken.setProvider(web3.currentProvider);
    //LottoTokenSale.setProvider(web3.currentProvider);

    web3.version.getNetwork((err, netId) => {
        let net_element = document.getElementById("net");
        let networkName = '';

        switch (netId) {
            case "1":
                networkName = "Main";
                break;
            case "2":
                networkName = "Morden";
                break;
            case "3":
                networkName = "Ropsten";
                break;
            case "4":
                networkName = "Rinkeby";
                break;
            case "42":
                networkName = "Kovan";
                break;
            default:
                networkName = "로컬";
        }
        net_element.innerHTML = networkName;
    });


    web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("There was an error fetching your accounts.");
        return;
      }
      if (accs.length == 0) {
        alert("지갑 계정의 주소가 0개입니다. 다시 확인해주시기 바랍니다.");
        return;
      }
      accounts = accs;
      account = accounts[0];
      LottoToken.deployed().then(function(instance) {
        ltt = instance;
        self.refreshBalance();
        self.totalBalance();
      })
    });
  },

  setStatus: function(message) {
    let status = document.getElementById("status");
    status.innerHTML = message;
  },

  refreshBalance: function() {
    const self = this;

    ltt.balanceOf.call(account)
       .then(function(value) {
         let balance_element = document.getElementById("balance");
         balance_element.innerHTML = value.valueOf();

       }).catch(function(e) {
         console.log(e);
         self.setStatus("계정 호출 에러 발생! 로그 확인 요망");
       });
  },

  totalBalance: function(){
      ltt.totalSupply.call().then(function(value){
          console.log(value, value.toString(), '총 코인 개수')
      });
  },

  //코인 보내기
  sendCoin: function() {
    let self = this;
    let amount = parseInt(document.getElementById("amount").value);
    let receiver = document.getElementById("receiver").value;

    this.setStatus("전송 대기중");

    let ltt;
      LottoToken.deployed().then(function(instance) {
      ltt = instance;
      return ltt.transfer(receiver, amount, {from: account});
    }).then(function() {
      self.setStatus("전송 완료");
      self.refreshBalance();
    }).catch(function(e) {
      console.log(e);
      self.setStatus("에러 발생! 로그 확인 요망");
    });
  },

  //로또 게임 만들기
  _createLottoGame: function() {
      let self = this;
      let name = document.getElementById("freceiver").value;
      ltt.createLottoGame(name, {from: account, gas: 27000}).then(function(value){
          console.log(value);
      })

  },

  //게임 상세 보기
  detailGame: function(){
      let self = this;
      let gameId = parseInt(document.getElementById("gameId").value);
      ltt.detailGameOf.call(gameId).then(function(game){
            console.log(game);
      })
  }




};

window.addEventListener('load', function() {
  if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 MetaCoin, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
    window.web3 = new Web3(web3.currentProvider);
  } else {
    console.warn("No web3 detected. Falling back to http://127.0.0.1:9545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));
  }

  App.start();
});
