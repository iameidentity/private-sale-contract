pragma solidity ^0.4.18;

/**
 * IAME PRESALE CONTRACT
 *
 * Version 0.1
 *
 * Author IAME Ltd
 *
 * MIT LICENSE Copyright 2018 IAME Ltd
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 **/


/**
 *
 * Important information about the IAME token presale
 *
 * For details about the IAME token presale, and in particular to find out
 * about risks and limitations, please visit:
 *
 * http://www.iame.io
 *
 **/


contract Owned {
  address public owner;

  function Owned() internal{
    owner = msg.sender;
  }

  modifier onlyOwner() {
    if (msg.sender != owner) {
      revert();
    }
    _;
  }
}

/// ----------------------------------------------------------------------------------------
/// @title IAME Presale Contract
/// @author IAME Ltd
/// @dev Changes to this contract will invalidate any security audits done before.
/// ----------------------------------------------------------------------------------------
contract IAMEPresale is Owned {
  // -------------------------------------------------------------------------------------
  // TODO Before deployment of contract to Mainnet
  // 1. Confirm MINIMUM_PARTICIPATION_AMOUNT below
  // 2. Adjust PRESALE_START_DATE and confirm the presale period
  // 3. Test the deployment to a dev blockchain or Testnet
  // 4. A stable version of Solidity has been used. Check for any major bugs in the
  //    Solidity release announcements after this version.
  // -------------------------------------------------------------------------------------

  // Keep track of the total funding amount
  uint256 public totalFunding;

  // Minimum amount per transaction for public participants
  uint256 public constant MINIMUM_PARTICIPATION_AMOUNT = 1 ether;

  // Public presale period
  uint256 public PRESALE_START_DATE;
  uint256 public PRESALE_END_DATE;

  /// @notice This is the constructor to set the dates
  function IAMEPresale() public{
    PRESALE_START_DATE = now + 10 * 1 minutes; // 'now' is the block timestamp
    PRESALE_END_DATE = now + 1 weeks;
  }

  /// @notice Keep track of all participants contributions, including both the
  ///         preallocation and public phases
  /// @dev Name complies with ERC20 token standard, etherscan for example will recognize
  ///      this and show the balances of the address
  mapping (address => uint256) public balanceOf;

  /// @notice Log an event for each funding contributed during the public phase
  event LogParticipation(address indexed sender, uint256 value, uint256 timestamp);


  /// @notice A participant sends a contribution to the contract's address
  ///         between the PRESALE_STATE_DATE and the PRESALE_END_DATE
  /// @notice Only contributions bigger than the MINIMUM_PARTICIPATION_AMOUNT
  ///         are accepted. Otherwise the transaction
  ///         is rejected and contributed amount is returned to the participant's
  ///         account
  /// @notice A participant's contribution will be rejected if the presale
  ///         has been funded to the maximum amount
  function () public payable {
    // A participant cannot send funds before the presale start date
    if (now < PRESALE_START_DATE) revert();
    // A participant cannot send funds after the presale end date
    if (now > PRESALE_END_DATE) revert();
    // A participant cannot send less than the minimum amount
    if (msg.value < MINIMUM_PARTICIPATION_AMOUNT) revert();
    // Register the participant's contribution
    addBalance(msg.sender, msg.value);
  }

  /// @notice The owner can withdraw ethers already during presale,
  function ownerWithdraw(uint256 value) external onlyOwner {
    if (!owner.send(value)) revert();
  }

  /// @dev Keep track of participants contributions and the total funding amount
  function addBalance(address participant, uint256 value) private {
    // Participant's balance is increased by the sent amount
    balanceOf[participant] = safeIncrement(balanceOf[participant], value);
    // Keep track of the total funding amount
    totalFunding = safeIncrement(totalFunding, value);
    // Log an event of the participant's contribution
    LogParticipation(participant, value, now);
  }

  /// @dev Add a number to a base value. Detect overflows by checking the result is larger
  ///      than the original base value.
  function safeIncrement(uint256 base, uint256 increment) private pure returns (uint256) {
    uint256 result = base + increment;
    if (result < base) revert();
    return result;
  }

}
