const { expect } = require("chai");
require("hardhat-gas-reporter");

describe("Test MiMC", function () {
  it("Test MiMC", async function () {
    let Hasher = await ethers.getContractFactory("Hasher");
    let hasher = await Hasher.deploy();
    console.log(`hasher : ${hasher.address}`)

    let c = await hasher.getC({ gasLimit: 10000000000 })
    console.log(`c : ${c}`)

    let hash = await hasher.hash([1000, 2000], { gasLimit: 10000000000 })
    console.log(`hash : ${hash}`)
    expect(hash).to.equal(6213744475698949925836804247423411578377719488321982497116899109773276757104n)
  });
});
