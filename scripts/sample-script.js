// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const TunesArt = await hre.ethers.getContractFactory("TunesArt");
  const tunesArt = await TunesArt.deploy();

  const provider = hre.ethers.provider;

  await tunesArt.deployed();

  console.log("tunesArt deployed to:", tunesArt.address);

  console.log(await tunesArt.getTokenOwner(2414));

  await tunesArt.setSupport(10000000000000000n);


  await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: ["0xc0a227a440aA6432aFeC59423Fd68BD00cAbB529"],
  });
  
  const signer = await ethers.getSigner("0xc0a227a440aA6432aFeC59423Fd68BD00cAbB529")


  oldbalance = await provider.getBalance("0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266");
  let overrides = {
    value: ethers.utils.parseEther("0.05")     
  };
  await tunesArt.connect(signer).setTuneMetaData(2414, "Tune 2414", "Tune 2414 description", "https://www.youtube.com/watch?v=dQw4w9WgXcQ", "thesoberguy13", "", overrides);
  newbalance = await provider.getBalance("0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266");

  console.log(await tunesArt.getTuneMetaData(2414));

  console.log("old balance:", oldbalance.toString());
  console.log("new balance:", newbalance.toString());


  console.log(ethers.utils.formatEther(newbalance.sub(oldbalance)));
  console.log(await tunesArt.owner());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
