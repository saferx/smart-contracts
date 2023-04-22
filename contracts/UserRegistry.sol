// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2;

contract UserRegistry {

	struct History {
		uint256 tokenId;
		uint32 amount;
		uint256 timestamp;
		address patient;
		address pharmacist;
	}

	struct User {
		string name;
		uint role; 
	}

	mapping(address => User) private users;
	mapping(address => History[]) private userHistory;

	function initUser(string memory _name, uint _role) public {
		require(bytes(_name).length > 0, "Invalid name length");
		require(users[msg.sender].role == 0, "User already initialised");
		require(_role > 0 && _role <= 3, "Invalid role input");
		users[msg.sender] = User(_name, _role);
	}

	function getUser() public view returns (User memory) {
		return users[msg.sender];
	}

	function getUser(address _address) public view returns (User memory) {
		require(
			isPatient(_address) || isPharmacist(_address) || isDoctor(_address),
			"You are unauthorised to retrieve user details by address."
		);
		return users[msg.sender];
	}

	function isPatient(address add) public view returns (bool) {
		return users[add].role == 1;
	}

	function isPharmacist(address add) public view returns (bool) {
		return users[add].role == 2;
	}

	function isDoctor(address add) public view returns (bool) {
		return users[add].role == 3;
	}

	function deleteUser() public {
		delete users[msg.sender];
	}

	function getHistory() public view returns (History[] memory) {
		return userHistory[msg.sender];
	}

	function getHistory(address _address) public view returns (History[] memory) {
		require(isPharmacist(msg.sender) || isDoctor(msg.sender), "You are unauthorised to retrieve history by address.");
		return userHistory[_address];
	}

	function addHistory(address _address, uint256 _tokenId, uint32 _amount, uint256 _timestamp, address _patient, address _pharmacist) public {
		userHistory[_address].push(History(_tokenId, _amount, _timestamp, _patient, _pharmacist));
	}

}
