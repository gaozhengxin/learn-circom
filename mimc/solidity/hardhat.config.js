require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.5.7",
      },
      {
        version: "0.8.17",
        settings: {},
      },
    ],
  },
};
