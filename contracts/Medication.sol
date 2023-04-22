// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "./MedicationUnits.sol";
import "./MedicationData.sol";
import "./UserRegistry.sol";

contract Medication is ERC721URIStorage, Ownable {

	MedicationData private medicationData;
	mapping(uint256 => MedicationUnits) private medicationUnits;
	UserRegistry userRegistry;
	uint256 tokenCounter;

	constructor(UserRegistry _userRegistry) ERC721("SafeRx Medication", "RXM") {
		userRegistry = _userRegistry;
		medicationData = new MedicationData();
		tokenCounter = 0;
	}

	function mint(address _patient, uint32 _quantity, string memory _name, uint32 _dosage, string memory _remarks, string memory _pid) public {
		require(userRegistry.isDoctor(msg.sender), "Only doctors are authorised to mint new prescriptions.");
		require(userRegistry.isPatient(_patient), "The receiver entered is not a valid patient address.");
		_mint(_patient, ++tokenCounter);
		medicationUnits[tokenCounter] = new MedicationUnits();
		medicationUnits[tokenCounter].generate(_quantity);
		medicationData.add(tokenCounter, _name, _dosage, _remarks, _pid);
	}

	function redeem(uint256 _tokenId, address _pharmacist, uint32 _amount) public {
		require(userRegistry.isPatient(msg.sender), "Only patients can use the 'redeem' function.");
		require(userRegistry.isPharmacist(_pharmacist), "The receiver inputted is not a valid pharmacist address.");
		require(_exists(_tokenId));
		require(_amount > 0, "Redemption amount must be greater than 0.");
		medicationUnits[_tokenId].burn(_amount);
		userRegistry.addHistory(msg.sender, _tokenId, _amount, msg.sender, _pharmacist);
		userRegistry.addHistory(_pharmacist, _tokenId, _amount, msg.sender, _pharmacist);
	}

	function getBalanceFor(uint256 _tokenId) external view returns (uint256) {
		return medicationUnits[_tokenId].balanceOf(address(this));
	}

	function getBalancesFor(uint256[] memory _tokenIds) external view returns (uint256[] memory) {
		uint256[] memory res = new uint256[](_tokenIds.length);
		for (uint256 i = 0; i < _tokenIds.length; i++) {
			res[i] = this.getBalanceFor(_tokenIds[i]);
		}
		return res;
	}

	function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
		return medicationData.makeURI(_tokenId);
	}

}
