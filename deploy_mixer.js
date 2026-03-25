const hre = require("hardhat");

async function main() {
  const Mixer = await hre.ethers.getContractFactory("ShieldedMixer");
  const mixer = await Mixer.deploy();

  await mixer.waitForDeployment();
  console.log(`Privacy Mixer deployed to: ${await mixer.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
