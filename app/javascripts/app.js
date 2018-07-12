// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";

// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
import lottotoken_artifacts from '../../build/contracts/LottoToken.json'

// MetaCoin is our usable abstraction, which we'll use through the code below.
const LottoToken = contract(lottotoken_artifacts);

// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
var accounts;
var account;
let networkId;
let ltt;

window.App = {
  start: function() {
    var self = this;

    // Bootstrap the MetaCoin abstraction for Use.
    LottoToken.setProvider(web3.currentProvider);

    web3.version.getNetwork((err, netId) => {
        console.log(netId);
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
                networkName = "Unknown";
        }
        net_element.innerHTML = networkName;
    });


    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("There was an error fetching your accounts.");
        return;
      }

      if (accs.length == 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
        return;
      }

      accounts = accs;
      account = accounts[0];

      console.log(accounts, account);

      self.refreshBalance();

    });
  },

  setStatus: function(message) {
    let status = document.getElementById("status");
    status.innerHTML = message;
  },

  refreshBalance: function() {
    const self = this;

    LottoToken.deployed().then(function(instance) {
      ltt = instance;

      self.totalBalance();
      return ltt.balanceOf.call(account);
    }).then(function(value) {
      var balance_element = document.getElementById("balance");
      balance_element.innerHTML = value.valueOf();

    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error getting balance; see log.");
    });
  },

  totalBalance: function(){
      ltt.totalSupply.call().then(function(value){
          console.log(value, value.toString(), '총금액')
      });
  }

  /*sendCoin: function() {
    var self = this;

    var amount = parseInt(document.getElementById("amount").value);
    var receiver = document.getElementById("receiver").value;

    this.setStatus("Initiating transaction... (please wait)");

    var meta;
      LottoToken.deployed().then(function(instance) {
      meta = instance;
      return meta.sendCoin(receiver, amount, {from: account});
    }).then(function() {
      self.setStatus("Transaction complete!");
      self.refreshBalance();
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error sending coin; see log.");
    });
  }*/
};

window.addEventListener('load', function() {
  if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 MetaCoin, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
    window.web3 = new Web3(web3.currentProvider);
  } else {
    console.warn("No web3 detected. Falling back to http://127.0.0.1:9545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7574"));
  }

  App.start();
});
