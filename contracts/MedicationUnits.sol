// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MedicationUnits is ERC20, Ownable {

	bool public generated = false;

	constructor() ERC20("SafeRx Medication Unit", "RXU") {}

	function generate(uint32 _quantity) external onlyOwner {
		require(!generated, "Already Generated");
		generated = true;
		_mint(msg.sender, _quantity);
	}

	function burn(uint32 _amount) external {
		_burn(msg.sender, _amount);
	}

	function getBalance() external view returns (uint256) {
		return balanceOf(msg.sender);
	}

}
