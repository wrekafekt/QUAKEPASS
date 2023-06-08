// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract QUAKEPASS is ERC721Enumerable, Ownable {

    struct Patron {
        uint16 attendanceCount;
    }

    mapping(uint256 => Patron) private _patronData;

    event NewURIAvailable(uint256 tokenId, string newURI);

    constructor() ERC721("QUAKEPASS", "QPASS") {}

    function mintNFT(address recipient) external onlyOwner returns (uint256) {
        uint256 newItemId = totalSupply();
        _mint(recipient, newItemId);
        _patronData[newItemId] = Patron({ attendanceCount: 0 });

        return newItemId;
    }

    function updateAttendance(uint256 tokenId) external onlyOwner {
        require(_exists(tokenId), "Token does not exist");

        Patron storage patron = _patronData[tokenId];
        patron.attendanceCount += 1;

        if (patron.attendanceCount >= 5) {
            emit NewURIAvailable(tokenId, calculateNewURI(patron.attendanceCount));
        }
    }

    function calculateNewURI(uint16 attendanceCount) private pure returns (string memory) {
        string memory baseURL = "https://github.com/wrekafekt/quake/blob/main/"; // Replace with your base URL

        if (attendanceCount < 5) {
            return string(abi.encodePacked(baseURL, "quake_pass_proto.png"));
        } else if (attendanceCount < 10) {
            return string(abi.encodePacked(baseURL, "quake_pass_5_proto.png"));
        } else if (attendanceCount < 20) {
            return string(abi.encodePacked(baseURL, "quake_pass_10_proto.png"));
        } else {
            return string(abi.encodePacked(baseURL, "quake_pass_20_proto.png"));
        }
    }
}
