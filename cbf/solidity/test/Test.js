const { expect } = require("chai");
require("hardhat-gas-reporter");

const bitsStr = "01010000000100000000000001000100010001010100010002010000000000000000000001010000000100000001000000000100000000020001010100010000010100000000000001000000000000000000000001010200000100000101010201010200010100000101000000000101010000010101030001000000000101000000000000010100000000010000010100000001000000000000000101000000000000000001000001000000010000010000010000010001010002000101010001010001000000000100010001000000020000000100000000000100010101010000000000000000010000000000010101010000000100000100010001010001000101000001010100000000000301000000010002000001000000000000000000010001000101010000000000000000000000010101000000000100000000000001000001010000000100000101000100000000000000010001020001000000000201010001000100010000000000000300000101000000000000000000000000000100000000020000000100000001010100010000010101010000010000000001000000000100000000010000010000000000000001010100000101000000000001020000000000000000000001010100000001000101010100010000000101000001010102010100000001000000000101020000020001000000000000010001010001020100000200010001000200000000000200000000000000010000000000000101000001000100000000000100000000000001000000000100000100010000000000010101000200000100000000000000010000000000000001000000020001000000010101010002000000000200000000010001000100000100000000000101000001010000000000000000010001000000000001030200000000000000000001000001000000010000010100000000010000000202000000010001010002000200010100000200010000000001000102000001000000000000010100010001000100000000010101000101010000000000010101000000010000000201000000000000000000000100020100010100010102000000010000000100010001010000010001000000010000010301000100000100000000020001000000000200000000010000000001010101000000000000000100010000010100000100010001020000010100020001000101000001000000000001000000000001000000000100000100010100000000000000000000010100000000000000000002010001000100000000000000000101000100000000010000000001000001010000010001010000000100010000000000000000000000000101010000000000010000000000000000000201010000000002010000000102000102000001"
const pi_a = ["0x20c0314142fb2d5a2ee9e421bb1ad007e6c11043c881c832a4ac996e788c6224", "0x0aa230800b827494e37c16aa7720d0b587954a938e92f18fe0a522b249d25651"]
const pi_b = [["0x1f5826847cf71b9072d3a7d9b50cc5415d0c9c86d52cb57449e5733272c85608", "0x26f8c8aa7ff0b622567fff2db9dcced3a4d760b5bf61ff74c431aad1e7b35bb3"], ["0x01908e2682af832396f47c48b881a76ec6f23d19f98051a2e833d7755af6c3a0", "0x09abbd27a63861b3f37af0552b76733b59a5e37889a93df6e20dc1cf1c374ee6"]]
const pi_c = ["0x00348b589998a43d44f8ce0563da5cc513d1e71f917b0f6c0d91b51a5892daef", "0x09b6f9ce95c1bc9b0db2e4e2772017c9375dccf9e4d07c04eb82e8dc0045f572"]

describe("CBF Verifier", function () {
  it("Test CBF Verifier", async function () {
    let IC_P1 = await ethers.getContractFactory("IC_P1");
    let ic_p1 = await IC_P1.deploy();

    let IC_P2 = await ethers.getContractFactory("IC_P2");
    let ic_p2 = await IC_P2.deploy();

    let IC_P3 = await ethers.getContractFactory("IC_P3");
    let ic_p3 = await IC_P3.deploy();

    let IC_P4 = await ethers.getContractFactory("IC_P4");
    let ic_p4 = await IC_P4.deploy();

    let IC_P5 = await ethers.getContractFactory("IC_P5");
    let ic_p5 = await IC_P5.deploy();

    let IC_P6 = await ethers.getContractFactory("IC_P6");
    let ic_p6 = await IC_P6.deploy();

    let IC_P7 = await ethers.getContractFactory("IC_P7");
    let ic_p7 = await IC_P7.deploy();

    let IC_P8 = await ethers.getContractFactory("IC_P8");
    let ic_p8 = await IC_P8.deploy();

    let IC_P9 = await ethers.getContractFactory("IC_P9");
    let ic_p9 = await IC_P9.deploy();

    await ic_p1.deployed();
    await ic_p2.deployed();
    await ic_p3.deployed();
    await ic_p4.deployed();
    await ic_p5.deployed();
    await ic_p6.deployed();
    await ic_p7.deployed();
    await ic_p8.deployed();
    await ic_p9.deployed();

    console.log(`ic_p1 : ${ic_p1.address}`)
    console.log(`ic_p2 : ${ic_p2.address}`)
    console.log(`ic_p3 : ${ic_p3.address}`)
    console.log(`ic_p4 : ${ic_p4.address}`)
    console.log(`ic_p5 : ${ic_p5.address}`)
    console.log(`ic_p6 : ${ic_p6.address}`)
    console.log(`ic_p7 : ${ic_p7.address}`)
    console.log(`ic_p8 : ${ic_p8.address}`)
    console.log(`ic_p9 : ${ic_p9.address}`)

    let Verifier = await ethers.getContractFactory("Verifier");
    let verifier = await Verifier.deploy([ic_p1.address, ic_p2.address, ic_p3.address, ic_p4.address, ic_p5.address, ic_p6.address, ic_p7.address, ic_p8.address, ic_p9.address]);
    await verifier.deployed();
    console.log(`verifier : ${verifier.address}`)

    let input = await verifier.stringToNumbers(bitsStr);
    console.log(`input : ${input}`);

    let res = await verifier.verifyProof_string(pi_a, pi_b, pi_c, bitsStr);
    console.log(`res : ${res}`)
    expect(res).equal(true);
  });
});
