// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./LinkedERC20.sol";

contract TokenFactory {
    address[] public deployedTokens;

    event TokenDeployed(address tokenAddress);

    // Deploy the reflection-based token
    function deployToken(
        address linkedNFTContract,
        uint256 privilegedNFTCount,
        string memory name,
        string memory symbol
    ) external {
            LinkedERC20 newToken = new LinkedERC20(
                msg.sender,
                linkedNFTContract,
                address(this),
                name,
                symbol,
                privilegedNFTCount
            );
            deployedTokens.push(address(newToken));
            emit TokenDeployed(address(newToken));
    }

    function transfer(
        address token,
        address recipient,
        uint256 amount
    ) external {
        ERC20(token).transfer(recipient, amount);
    }

    function transferFrom(
        address token,
        address sender,
        address recipient,
        uint256 amount
    ) external {
        ERC20(token).transferFrom(sender, recipient, amount);
    }

    function mint(
        address token,
        address to,
        uint256 amount
    ) external {
        LinkedERC20(token).mint(to, amount);
    }

    function setNFTFeePercentage(
        address token,
        uint256 percentage
    ) external {
            LinkedERC20(token).setTitleFeePercentage(percentage);
    }

    function addAttributesInBatch(
        address token,
        uint256[] memory ids,
        uint256[] memory percentages
    ) external {
            LinkedERC20(token).addAttributesInBatch(ids, percentages);
    }

    function claimTitleFee(
        address token,
        uint256 titledNFTId
    ) external {
            LinkedERC20(token).claimTitleFee(titledNFTId);
    }

    function getDeployedTokens() external view returns (address[] memory) {
        return deployedTokens;
    }
}
