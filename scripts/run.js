const main = async () => {
    // Compile our contract and generate the necessary files we need to work with our contract under the artifacts directory.
    const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");

    // Create a local Ethereum network for us, but just for this contract.
    // Then, after the script completes it'll destroy that local network.
    const epicNFTContract = await nftContractFactory.deploy()

    // Wait until our contract is officially mined and deployed to our local blockchain!
    await epicNFTContract.deployed();

    console.log("Contract deployed to:", epicNFTContract.address);

    const firstMintTxn = await epicNFTContract.makeAnEpicNFT();
    await firstMintTxn.wait();

    // const [_, address2] = await hre.ethers.getSigners();
    // const secondMintTxn = await epicNFTContract.connect(address2).makeAnEpicNFT();
    // await secondMintTxn.wait();
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.log(error);
        process.exit(1)
    });