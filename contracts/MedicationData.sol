// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract MedicationData {
	
	struct Data {
		string name;
		uint32 dosage;
		string remarks;
		string pid;
		uint256 timestamp;
	}

	mapping (uint256 => Data) private data;

	function add(uint256 tokenId, string memory _name, uint32 _dosage, string memory _remarks, string memory _pid) public {
		data[tokenId] = Data(_name, _dosage, _remarks, _pid, block.timestamp);
	}

	function makeURI(uint256 _tokenId) public view returns (string memory) {
		Data memory dat = data[_tokenId];
		string memory json = string(
			abi.encodePacked(
				'{',
				'"name": "', dat.name, '",',
				'"description": "This is an ERC721 NFT that represents a medical prescription. You can use our platform to view you actual balance, even though your wallet says you only have 1x.",',
				'"attributes": [',
				'{"trait_type": "Remarks", "value": "', dat.remarks, '"},',
				'{"trait_type": "Dosage", "value": ', Strings.toString(dat.dosage), '},',
				'{"trait_type": "Date", "value": ', Strings.toString(dat.timestamp), '},',
				'{"trait_type": "Prescription ID", "value": "', dat.pid, '"}',
				']',
				'}'
			)
		);
		return string(abi.encodePacked('data:application/json;base64,', Base64.encode(bytes(json))));
	}

}
