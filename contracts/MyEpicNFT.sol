// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract MyEpicNFT is ERC721URIStorage {
  event NewEpicNFTMinted(address indexed sender, uint tokenId);

  // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  string[] firstWords = ["Ethereum", "Solana", "Tezos", "Near", "Cardano", "Binance", "Luna", "Avalanche", "Elrond", "Harmony", "Cronos", "Polkadot", "Cosmos", "Fantom"];
  string[] secondWords = ["Matic", "Joe", "Raydium", "Sundae", "Moonbeam", "Acala", "Compound", "Aave", "Curve", "Convex", "Gari", "Ardana", "Maiar", "Chainlink", "Uniswap"];
  string[] thirdWords = ["Solchick", "Illuvium", "Monkeyball", "Atlas", "Wilder", "Decentraland", "Sandbox", "Axie", "Enjin", "Effinity", "Cryowar", "Guardians", "Bigtime", "Gala"];

  // We need to pass the name of our NFTs token and its symbol.
  constructor() ERC721 ("SquareNFT", "SQUARE") {
    console.log("This is my NFT contract. Woah!");
  }

  // A function our user will hit to get their NFT.
  function makeAnEpicNFT() public {
    // Get the current tokenId, this starts at 0.
    uint256 newItemId = _tokenIds.current();

    string memory firstWord = pickRandomFirstWord(newItemId);
    string memory secondWord = pickRandomSecondWord(newItemId);
    string memory thirdWord = pickRandomThirdWord(newItemId);

    string memory combinedWord = string(abi.encodePacked(firstWord, secondWord, thirdWord));

    string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

    string memory finalSvgBase64 = Base64.encode(abi.encodePacked(finalSvg));

    string memory jsonBase64 = Base64.encode(abi.encodePacked(
      '{"name": "',
      combinedWord,
      '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
      finalSvgBase64,
      '"}'
    ));

    string memory finalTokenUri = string(abi.encodePacked("data:application/json;base64,", jsonBase64));

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");
  
    // Actually mint the NFT to the sender using msg.sender.
    _safeMint(msg.sender, newItemId);

    // Set the NFTs data.
    _setTokenURI(newItemId, finalTokenUri);

    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    // Increment the counter for when the next NFT is minted.
    _tokenIds.increment();

    emit NewEpicNFTMinted(msg.sender, newItemId);
  }

  function pickRandomFirstWord(uint tokenId) internal view returns (string memory) {
    uint randomNum = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    randomNum = randomNum % firstWords.length;
    return firstWords[randomNum];
  }

  function pickRandomSecondWord(uint tokenId) internal view returns (string memory) {
    uint randomNum = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    randomNum = randomNum % secondWords.length;
    return secondWords[randomNum];
  }

  function pickRandomThirdWord(uint tokenId) internal view returns (string memory) {
    uint randomNum = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    randomNum = randomNum % thirdWords.length;
    return thirdWords[randomNum];
  }

  function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }
}
