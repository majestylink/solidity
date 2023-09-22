const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Majesty contract", function () {
  let MajestyToken;
  let majestyToken;
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();

    MajestyToken = await ethers.getContractFactory("MajestyToken");
    majestyToken = await MajestyToken.deploy(100000000, 1000);
  });

  describe("Deployment", function() {
    it("Should deploy with the correct name and symbol", async function () {
        expect(await majestyToken.name()).to.equal("MajestyToken");
        expect(await majestyToken.symbol()).to.equal("MYT");
      });
    
      it("Should set the owner correctly", async function () {
        expect(await majestyToken.owner()).to.equal(owner.address);
      });
    
      it("Should mint initial supply to owner", async function () {
        const ownerBalance = await majestyToken.balanceOf(owner.address);
        expect(ownerBalance).to.equal(70000000n * 10n ** 18n);
      });
    
      it("Should set blockReward correctly", async function () {
        expect(await majestyToken.blockReward()).to.equal(1000n * 10n ** 18n);
      });
    
      it("Should allow the owner to change the reward", async function () {
        const newReward = 2000n;
        await majestyToken.connect(owner).setReward(newReward);
        expect(await majestyToken.blockReward()).to.equal(newReward * 10n ** 18n);
      });
    
      it("Should not allow non-owners to change the reward", async function () {
        const newReward = 2000;
        await expect(
          majestyToken.connect(addr1).setReward(newReward)
        ).to.be.revertedWith("Unauthorized, only the owner can call this function");
      });
    
      it("Should set the max capped supply to the argument provided during deployment", async function () {
        const cap = await majestyToken.cap();
        expect(cap).to.equal(100000000n * 10n ** 18n);
      });
  })

    describe("Transactions", function () {
        it("Should transfer tokens between accounts", async function () {
            await majestyToken.transfer(addr1.address, 50);
            const addr1Balance = await majestyToken.balanceOf(addr1.address);
            expect(addr1Balance).to.equal(50);

            await majestyToken.connect(addr1).transfer(addr2.address, 50);
            const addr2Balance = await majestyToken.balanceOf(addr2.address);
            expect(addr2Balance).to.equal(50);
        });
    })
  

});
