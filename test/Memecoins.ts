import { ethers, upgrades } from 'hardhat'

describe('Memecoins contract tests', function () {
  let Memecoins, memecoins, owner

  before(async function () {
    ;[owner] = await ethers.getSigners()
    Memecoins = await ethers.getContractFactory('Memecoins')
    memecoins = await upgrades.deployProxy(Memecoins, [])
  })

  describe('createMemecoin', function () {
    it('should create a new Memecoin instance', async function () {
      const name = 'TestCoin'
      const symbol = 'TST'
      const premintAmount = ethers.parseUnits('1000', 18)
      const mintRate = 1
      const supplyCap = ethers.parseUnits('1000000', 18)

      console.log(
        owner.address,
        name,
        symbol,
        premintAmount,
        mintRate,
        supplyCap
      )

      const tx = await memecoins.createMemecoin(
        owner.address,
        name,
        symbol,
        premintAmount,
        mintRate,
        supplyCap
      )
      await tx.wait()
    })
  })
})
