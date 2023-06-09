async function main() {
	const UserRegistry = await ethers.getContractFactory("UserRegistry");
	console.log('Deploying UserRegistry...')
	const user_registry = await UserRegistry.deploy();
	const user_registry_address = user_registry.address
	console.log("UserRegistry deployed to address:", user_registry_address);

	const Medication = await ethers.getContractFactory("Medication");
	console.log('Deploying Medication...')
	const medication = await Medication.deploy(user_registry_address);
	const medication_address = medication.address
	console.log("Medication deployed to address:", medication_address);
}

main()
	.then(() => process.exit(0))
	.catch(e => {
		console.error(e)
		process.exit(1)
	})
