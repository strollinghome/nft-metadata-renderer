// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "solady/utils/Base64.sol";
import "solady/utils/LibString.sol";

/// @notice Library for rendering metadata for NFTs.
/// @author indreams.eth
library NFTMetadataRenderer {
    struct Field {
        string name;
        string value;
    }

    /// @notice Generate tokenURI metadata.
    /// @param name Name of NFT in metadata.
    /// @param description Description of NFT in metadata.
    /// @param mediaFields List of mediaFields to include in metadata.
    /// @param attributesData List of attributes to include in metadata.
    /// @param tokenId Token ID for specific token.
    /// @param size Size of entire edition to show.
    function tokenURIMetadata(
        string memory name,
        string memory description,
        Field[] memory mediaFields,
        string memory attributesData,
        uint256 tokenId,
        uint256 size
    ) internal pure returns (string memory) {
        return
            encodeMetadataJSON(
                createTokenURIMetadataJSON(
                    name,
                    description,
                    mediaFields,
                    attributesData,
                    tokenId,
                    size
                )
            );
    }

    /// @notice Generate contractURI metadata.
    /// @param name Name of NFT in metadata.
    /// @param description Description of NFT in metadata.
    /// @param mediaFields List of mediaFields to include in metadata.
    /// @param royaltyBPS Royalty basis points.
    /// @param royaltyRecipient Royalty recipient.
    function contractURIMetadata(
        string memory name,
        string memory description,
        Field[] memory mediaFields,
        uint256 royaltyBPS,
        address royaltyRecipient
    ) internal pure returns (string memory) {
        return
            encodeMetadataJSON(
                createContractURIMetadataJSON(
                    name,
                    description,
                    mediaFields,
                    royaltyBPS,
                    royaltyRecipient
                )
            );
    }

    function createTokenURIMetadataJSON(
        string memory name,
        string memory description,
        Field[] memory mediaFields,
        string memory attributesData,
        uint256 tokenId,
        uint256 size
    ) internal pure returns (bytes memory) {
        bytes memory tokenNumber;
        if (size > 0) {
            tokenNumber = abi.encodePacked("/", LibString.toString(size));
        }

        bytes memory mediaData;
        if (mediaFields.length > 0) {
            mediaData = abi.encodePacked(",", fieldData(mediaFields));
        }

        bytes memory attributes;
        if (bytes(attributesData).length > 0) {
            attributes = abi.encodePacked(
                ', "attributes": [',
                attributesData,
                "]"
            );
        }

        return
            abi.encodePacked(
                '{"name": "',
                name,
                " ",
                LibString.toString(tokenId),
                tokenNumber,
                '","',
                'description": "',
                description,
                '"',
                mediaData,
                attributes,
                "}"
            );
    }

    function createContractURIMetadataJSON(
        string memory name,
        string memory description,
        Field[] memory mediaFields,
        uint256 royaltyBPS,
        address royaltyRecipient
    ) internal pure returns (bytes memory) {
        bytes memory mediaData;
        if (mediaFields.length > 0) {
            mediaData = abi.encodePacked(",", fieldData(mediaFields));
        }

        return
            abi.encodePacked(
                '{"name": "',
                name,
                '", "description": "',
                description,
                '", "seller_fee_basis_points": ',
                LibString.toString(royaltyBPS),
                ', "fee_recipient": "',
                LibString.toHexString(uint256(uint160(royaltyRecipient)), 20),
                '"',
                mediaData,
                "}"
            );
    }

    /// @notice Encode the json bytes into base64 data uri format.
    /// @param json The json bytes to encode.
    function encodeMetadataJSON(
        bytes memory json
    ) internal pure returns (string memory) {
        return
            string.concat("data:application/json;base64,", Base64.encode(json));
    }

    /// @notice Encode the svg bytes into base64 data uri format.
    /// @param svg The svg bytes to encode.
    function encodeSVG(bytes memory svg) internal pure returns (string memory) {
        return string.concat("data:image/svg+xml;base64,", Base64.encode(svg));
    }

    /// @notice Generate key/value data for metadata.
    /// [{name: "x", value: "y"}, {name:"a", value: "b"}] -> "a": "b", "x": "y"
    /// @param fields List of fields to include in metadata.
    function fieldData(
        Field[] memory fields
    ) internal pure returns (string memory) {
        if (fields.length == 0) return "";

        string memory tokenMedia = string.concat(
            '"',
            fields[0].name,
            '": "',
            fields[0].value,
            '"'
        );

        for (uint256 i = 1; i < fields.length; i++) {
            tokenMedia = string.concat(
                '"',
                fields[i].name,
                '": "',
                fields[i].value,
                '",',
                tokenMedia
            );
        }
        return tokenMedia;
    }
}
