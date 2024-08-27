// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract LinkedERC20 is ERC20, Ownable {
    IERC721 public linkedNFTContract;
    uint256 public nftFeePercentage;
    mapping(uint256 => uint256) public nftFeePercentages;
    mapping(uint256 => uint256) public collectedNFTFeeByTokenId;
    uint256 public collectedNFTFee;
    uint256 public privilegedNFTCount;
    uint256[] public privilegedNFTIds;
    address public factory;

    constructor(
        address initialOwner,
        address _linkedNFTContract,
        address _factory,
        string memory name,
        string memory symbol,
        uint256 _privilegedNFTCount
    ) ERC20(name, symbol) Ownable(initialOwner) {
        linkedNFTContract = IERC721(_linkedNFTContract);
        factory = _factory;
        privilegedNFTCount = _privilegedNFTCount;
        mint(initialOwner, 1000000000000000000000000000);
    }

    modifier isCompleted() {
        require(
            privilegedNFTIds.length == privilegedNFTCount,
            "Attribute adding period is not over yet"
        );
        _;
    }

    modifier onlyOwnerOrFactory() {
        require(
            msg.sender == owner() || msg.sender == factory,
            "UnAuthorized caller"
        );
        _;
    }

    modifier isIntegrated() {
        require(
            checkIntegrityOfPercentage(),
            "Percentages has some integrity problems"
        );
        _;
    }
    function mint(address to, uint256 amount) onlyOwnerOrFactory public {
        _mint(to, amount);
    }

    function checkIntegrityOfPercentage() public view returns (bool) {
        uint256 sum = 0;
        for (uint256 i = 0; i < privilegedNFTCount; i++) {
            sum = sum + nftFeePercentages[privilegedNFTIds[i]];
        }
        if (sum == 1e18) return true;
        else return false;
    }

    function addAttributesInBatch(
        uint256[] memory ids,
        uint256[] memory percentages
    ) external onlyOwnerOrFactory {
        require(ids.length == percentages.length, "Array mismatch");
        for (uint256 i = 0; i < ids.length; i++) {
            nftFeePercentages[ids[i]] = percentages[i];
            privilegedNFTIds.push(ids[i]);
        }
    }

    function setTitleFeePercentage(uint256 percentage)
        external
        onlyOwnerOrFactory
    {
        require(percentage <= 100, "Invalid fee");
        nftFeePercentage = percentage;
    }

    function calculateNFTFee(uint256 nftId) public view returns (uint256) {
        uint256 share = (nftFeePercentages[nftId] * collectedNFTFee) / 1e18;
        return share - collectedNFTFeeByTokenId[nftId];
    }

    function claimTitleFee(uint256 nftId) external {
        require(msg.sender == linkedNFTContract.ownerOf(nftId), "Unauthorized");
        uint256 amount = calculateNFTFee(nftId);
        collectedNFTFeeByTokenId[nftId] += amount;
        transfer(msg.sender, amount);
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        isCompleted
        isIntegrated
        returns (bool)
    {
        uint256 fee = (amount * nftFeePercentage) / 100;
        collectedNFTFee += fee;
        super.transfer(address(this), fee);
        amount = amount - fee;
        return super.transfer(recipient, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override isCompleted isIntegrated returns (bool) {
        uint256 fee = (amount * nftFeePercentage) / 100;
        collectedNFTFee += fee;
        super.transferFrom(sender, address(this), fee);
        amount = amount - fee;
        return super.transferFrom(sender, recipient, amount);
    }
}
