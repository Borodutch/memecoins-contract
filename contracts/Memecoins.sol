//    _  __  __ ______ __  __ ______ _____ ____ _____ _   _
//   | ||  \/  |  ____|  \/  |  ____/ ____/ __ \_   _| \ | |
//  / __) \  / | |__  | \  / | |__ | |   | |  | || | |  \| |
//  \__ \ |\/| |  __| | |\/| |  __|| |   | |  | || | | . ` |
//  (   / |  | | |____| |  | | |___| |___| |__| || |_| |\  |
//   |_||_|  |_|______|_|  |_|______\_____\____/_____|_| \_|

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./Memecoin.sol";

contract Memecoins is Initializable {
  // Events
  event MemecoinCreated(address indexed memecoin, address indexed owner);

  uint256 public feeAmount;
  address public constant FEE_RECIPIENT =
    0xbf74483DB914192bb0a9577f3d8Fb29a6d4c08eE;

  function initialize(uint256 _feeAmount) public initializer {
    feeAmount = _feeAmount;
  }

  function createMemecoin(
    address initialOwner,
    string calldata name,
    string calldata symbol,
    uint256 premintAmount,
    uint256 initialMintPrice,
    uint256 initialSupplyCap
  ) public payable returns (Memecoin) {
    require(msg.value >= feeAmount, "Insufficient funds");
    payable(FEE_RECIPIENT).transfer(msg.value);

    Memecoin memecoin = new Memecoin();
    memecoin.initialize(
      initialOwner,
      name,
      symbol,
      premintAmount,
      initialMintPrice,
      initialSupplyCap
    );
    emit MemecoinCreated(address(memecoin), initialOwner);
    return memecoin;
  }
}
