pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";

import "../src/NFTMetadataRenderer.sol";

contract NFTMetadataRendererTest is Test {
    function test_tokenURIMetadata() external {
        NFTMetadataRenderer.Field[]
            memory mediaFields = new NFTMetadataRenderer.Field[](1);
        mediaFields[0] = NFTMetadataRenderer.Field({
            name: "image",
            value: "ipfs://"
        });

        assertEq(
            NFTMetadataRenderer.tokenURIMetadata(
                "NFT Name",
                "NFT Description",
                mediaFields,
                "",
                1,
                0
            ),
            "data:application/json;base64,eyJuYW1lIjogIk5GVCBOYW1lIDEiLCJkZXNjcmlwdGlvbiI6ICJORlQgRGVzY3JpcHRpb24iLCJpbWFnZSI6ICJpcGZzOi8vIn0="
        );
    }
}
