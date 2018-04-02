var IAMEPresale = artifacts.require("./IAMEPresale.sol");

contract('IAMEPresale', function(accounts) {
  /* Template code
  it("should assert true", function(done) {
    var i_a_m_e_presale = IAMEPresale.deployed();
    assert.isTrue(true);
    done();
  });
  */

  // Test Case#1 - Check the contract cannot receive less than 1 Ether
  it("should assert true", function() {
    var iamepresale;
    return IAMEPresale.deployed().then(function(instance){
      iamepresale = instance;
      return web3.eth.sendTransaction({ from: web3.eth.accounts[0], to: iamepresale.address, value: web3.toWei(0.5) })
    }).then(function (result) {
      console.log("0.5 ETH was accepted - ERROR");
      assert(false, '0.5 ETH was accepted - ERROR');
    }).catch(function(error) {
      if(error.toString().indexOf("revert") != -1) {
        console.log("We were expecting a REVERT - Got it!");
      } else {
        // if the error is something else (e.g., the assert from previous promise), then we fail the test
        assert(false, error.toString());
      }
    });
  });
});
