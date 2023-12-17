import { ethers, upgrades } from 'hardhat'
import { expect } from 'chai'

describe('MyERC721 contract tests', () => {
  let Memecoin, memecoin, owner

  before(async function () {
    ;[owner] = await ethers.getSigners()
    Memecoin = await ethers.getContractFactory('Memecoin')
    memecoin = await upgrades.deployProxy(Memecoin, [
      owner.address,
      'Memecoin',
      'MEME',
      ethers.parseUnits('1000', 18),
      1,
      ethers.parseUnits('1000000', 18),
    ])
  })

  describe('Initialization', function () {
    it('should have correct initial values', async function () {
      expect(await memecoin.name()).to.equal('Memecoin')
      expect(await memecoin.symbol()).to.equal('MEME')
    })
  })
})
