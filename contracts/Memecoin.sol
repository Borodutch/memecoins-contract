//    _  __  __ ______ __  __ ______ _____ ____ _____ _   _
//   | ||  \/  |  ____|  \/  |  ____/ ____/ __ \_   _| \ | |
//  / __) \  / | |__  | \  / | |__ | |   | |  | || | |  \| |
//  \__ \ |\/| |  __| | |\/| |  __|| |   | |  | || | | . ` |
//  (   / |  | | |____| |  | | |___| |___| |__| || |_| |\  |
//   |_||_|  |_|______|_|  |_|______\_____\____/_____|_| \_|

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20FlashMintUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/// @custom:security-contact memecoins@bdut.ch
contract Memecoin is
  Initializable,
  ERC20Upgradeable,
  ERC20BurnableUpgradeable,
  ERC20PausableUpgradeable,
  OwnableUpgradeable,
  ERC20PermitUpgradeable,
  ERC20VotesUpgradeable,
  ERC20FlashMintUpgradeable
{
  // State
  uint256 public mintRate;
  uint256 public supplyCap;
  address public constant FEE_RECIPIENT =
    0xbf74483DB914192bb0a9577f3d8Fb29a6d4c08eE;

  // Events
  event MintRateSet(uint256 newMintRate);
  event SupplyCapSet(uint256 newSupplyCap);

  function initialize(
    address initialOwner,
    string calldata name,
    string calldata symbol,
    uint256 premintAmount,
    uint256 initialMintRate,
    uint256 initialSupplyCap
  ) public initializer {
    mintRate = initialMintRate;
    supplyCap = initialSupplyCap;

    __ERC20_init(name, symbol);
    __ERC20Burnable_init();
    __ERC20Pausable_init();
    __Ownable_init(initialOwner);
    __ERC20Permit_init(name);
    __ERC20Votes_init();
    __ERC20FlashMint_init();

    _mint(initialOwner, premintAmount * 10 ** decimals());
  }

  function setMintRate(uint256 newMintRate) public onlyOwner {
    mintRate = newMintRate;
    emit MintRateSet(newMintRate);
  }

  function setSupplyCap(uint256 newSupplyCap) public onlyOwner {
    supplyCap = newSupplyCap;
    emit SupplyCapSet(newSupplyCap);
  }

  function pause() public onlyOwner {
    _pause();
  }

  function unpause() public onlyOwner {
    _unpause();
  }

  function mint() public payable {
    require(msg.value > 0, "No Ether sent");
    uint256 fee = (msg.value * 25) / 1000;
    payable(FEE_RECIPIENT).transfer(fee);
    uint256 remainingValue = msg.value - fee;
    uint256 amountToMint = remainingValue * mintRate;
    require(amountToMint > 0, "Insufficient Ether for minting");
    require(
      supplyCap == 0 || totalSupply() + amountToMint <= supplyCap,
      "Supply cap exceeded"
    );
    _mint(msg.sender, amountToMint);
  }

  // The following functions are overrides required by Solidity.

  function _update(
    address from,
    address to,
    uint256 value
  )
    internal
    override(ERC20Upgradeable, ERC20PausableUpgradeable, ERC20VotesUpgradeable)
  {
    super._update(from, to, value);
  }

  function nonces(
    address owner
  )
    public
    view
    override(ERC20PermitUpgradeable, NoncesUpgradeable)
    returns (uint256)
  {
    return super.nonces(owner);
  }
}
