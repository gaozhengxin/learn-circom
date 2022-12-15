//
// Copyright 2017 Christian Reitwiessner
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// 2019 OKIMS
//      ported to solidity 0.6
//      fixed linter warnings
//      added requiere error messages
//
//
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.11;
pragma experimental ABIEncoderV2;

import "./Pairling.sol";

abstract contract PointStore {
    using Pairing for *;

    function getPoint(uint256 index)
        public
        pure
        virtual
        returns (Pairing.G1Point memory);
}

contract Verifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G1Point alfa1;
        Pairing.G2Point beta2;
        Pairing.G2Point gamma2;
        Pairing.G2Point delta2;
        //Pairing.G1Point[] IC;
    }
    struct Proof {
        Pairing.G1Point A;
        Pairing.G2Point B;
        Pairing.G1Point C;
    }

    PointStore[] verifyingKey_IC;

    constructor(PointStore[] memory ICs) public {
        verifyingKey_IC = ICs;
    }

    function getIC(uint256 index)
        internal
        view
        returns (Pairing.G1Point memory)
    {
        verifyingKey_IC[index / 128].getPoint(index);
    }

    function verifyingKey() internal pure returns (VerifyingKey memory vk) {
        vk.alfa1 = Pairing.G1Point(
            3456481222474521332923197467522816336152602401642123396357706634747616332684,
            7032535602749439131109832251803094278402651328192481339461627849224184973189
        );

        vk.beta2 = Pairing.G2Point(
            [
                11969717101844716696998029532669216543609604502143855787379055093989518402701,
                7903314448171117649081184731556344010599492119257633798983543290925123522195
            ],
            [
                13263685522660664680512407948359037016917690112012925493739235507674075834444,
                6148512925216086702825180959978072703381999073656299251066370019528305811178
            ]
        );
        vk.gamma2 = Pairing.G2Point(
            [
                11559732032986387107991004021392285783925812861821192530917403151452391805634,
                10857046999023057135944570762232829481370756359578518086990519993285655852781
            ],
            [
                4082367875863433681332203403145435568316851327593401208105741076214120093531,
                8495653923123431417604973247489272438418190587263600148770280649306958101930
            ]
        );
        vk.delta2 = Pairing.G2Point(
            [
                11598574655779958339156920226355815787475434628942888512038586673028253314400,
                9864359466642146723920903118832945340528643186355188939740067041538740853969
            ],
            [
                88446477663980218602026131421343913085750623362545764088405878851477684153,
                15184941542869190509080174545472058196649851915964959427578936056151382594638
            ]
        );
        //vk.IC = new Pairing.G1Point[](1025);
    }

    function verify(uint8[] memory input, Proof memory proof)
        internal
        view
        returns (uint256)
    {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = verifyingKey();
        //require(input.length + 1 == vk.IC.length, "verifier-bad-input");
        require(input.length + 1 == 1025, "verifier-bad-input");
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint256 i = 0; i < input.length; i++) {
            require(
                uint256(input[i]) < snark_scalar_field,
                "verifier-gte-snark-scalar-field"
            );
            vk_x = Pairing.addition(
                vk_x,
                //Pairing.scalar_mul(vk.IC[i + 1], uint256(input[i]))
                Pairing.scalar_mul(getIC(i + 1), uint256(input[i]))
            );
        }
        //vk_x = Pairing.addition(vk_x, vk.IC[0]);
        vk_x = Pairing.addition(vk_x, getIC(0));
        if (
            !Pairing.pairingProd4(
                Pairing.negate(proof.A),
                proof.B,
                vk.alfa1,
                vk.beta2,
                vk_x,
                vk.gamma2,
                proof.C,
                vk.delta2
            )
        ) return 1;
        return 0;
    }

    /// @return r  bool true if proof is valid
    function verifyProof(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint8[1024] memory input
    ) public view returns (bool r) {
        Proof memory proof;
        proof.A = Pairing.G1Point(a[0], a[1]);
        proof.B = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.C = Pairing.G1Point(c[0], c[1]);
        uint8[] memory inputValues = new uint8[](input.length);
        for (uint256 i = 0; i < input.length; i++) {
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            return true;
        } else {
            return false;
        }
    }

    function verifyProof_bytes(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        string memory input
    ) public view returns (bool r) {
        return verifyProof(a, b, c, stringToNumbers(input));
    }

    function stringToNumbers(string memory input)
        public
        pure
        returns (uint8[1024] memory inputNumbers)
    {
        require(bytes(input).length == 2048);
        for (uint256 i = 0; i < 1024; i++) {
            inputNumbers[i] =
                (uint8(bytes(input)[2 * i]) - 48) *
                10 +
                (uint8(bytes(input)[2 * i + 1]) - 48);
        }
        return inputNumbers;
    }
}
