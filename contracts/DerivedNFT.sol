//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import 'base64-sol/base64.sol';
import "./TunesMetadata.sol";


contract DerivedTune is IERC721, ERC165, IERC721Metadata {
    

    IERC721Enumerable public tunes = IERC721Enumerable(0x52B1dd5c27705aa4DFd3889db223b5C4c84f6B54);
    TunesMetadata public tunesMetadata = TunesMetadata(0xe665f007f1f472073541539c35AC774dB6855853);

    address public metadataRegistryDevAddress = 0xc0a227a440aA6432aFeC59423Fd68BD00cAbB529;

    string private _name = "Derived Tunes";
    string private _symbol = "DTUNE";

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function totalSupply() public view returns (uint256) {
        return tunes.totalSupply();
    }

    function balanceOf(address owner) public override view returns (uint256 balance) {
        return tunes.balanceOf(owner);
    }


    function ownerOf(uint256 tokenId) public override view returns (address owner) {
        return tunes.ownerOf(tokenId);
    }

    function getApproved(uint256 tokenId) public view override returns (address operator) {
        return tunes.getApproved(tokenId);
    }

    function isApprovedForAll(address owner, address operator) public override view returns (bool) {
        return tunes.isApprovedForAll(owner, operator);
    }

    // Before using this, set this metadata on the TunesMetadata contract.
    // Make sure to use the standard keys like name, description and image to maintain 3rd party viewers support.
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(tunes.ownerOf(tokenId) != address(0), "ERC721Metadata: URI query for nonexistent token");

        return
            string(
                abi.encodePacked(
                    'data:application/json;base64,',
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                tunesMetadata.getMetadata(metadataRegistryDevAddress, 'name', tokenId),
                                '", "description":"',
                                tunesMetadata.getMetadata(metadataRegistryDevAddress, 'description', tokenId),
                                '", "image": "',
                                tunesMetadata.getMetadata(metadataRegistryDevAddress, 'image', tokenId),
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    // Can be invoked by anyone to update the ownership of the Derived Tune to official Tune owner  
    function claim(uint256 tokenId) public {
        emit Transfer(address(0), tunes.ownerOf(tokenId), tokenId);
    }



    //  ==========================================================
    //          Muted methods to make ERC721 interface work
    //  ==========================================================

    function approve(address to, uint256 tokenId) public override {
        require(false, "DerivedTune is not a transferable");
    }

    function setApprovalForAll(address operator, bool _approved) public override {
        require(false, "DerivedTune is not a transferable");
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        require(false, "DerivedTune is not a transferable");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        require(false, "DerivedTune is not a transferable");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) public override {
        require(false, "DerivedTune is not a transferable");
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

}
