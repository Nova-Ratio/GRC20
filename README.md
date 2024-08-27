Intended Use of the GRC20

The main purpose of the system is to allow users to deploy their own GRC20 tokens and link them to an NFT collection (like Azuki). This system supports the following features:

- Deploy Tokens: Users can deploy standard (GRC20) tokens that are linked to an NFT collection.
- Custom Fee Allocation: Users can set a title fee percentage for specific NFT holders based on the traits of the NFTs, like having a red background and a boombox on the offhand.
- Attribute Management: After deployment, users must add attributes to the contract that define the NFT IDs eligible to receive fees. The sum of all percentage values must equal 1e18 to avoid contract failures.
- Batch Attribute Addition: For large NFT collections, users can add attributes in batches, simplifying the process.
- Claim Title Fees: Once the token is deployed, NFT holders can claim their title fees by interacting with the deployed token.

Deployment and Interaction Workflow

The intended workflow is as follows:
1. Deploy a token (GRC20) and link it to the NFT collection.
2. After deployment, set the attributes of privileged NFTs (e.g., Azuki NFTs with specific traits) and ensure the sum of the percentages equals 1e18.
3. Set the privileged NFT fee percentage for title fees.
4. Once deployed, the token is fully operational, allowing transfers, sales, and fee distribution among NFT and token holders.
5. NFT holders can claim title fees through the frontend or directly via the contract.

Notes

You can view the Azuki attributes CSV file in this folder.
