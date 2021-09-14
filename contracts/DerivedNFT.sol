//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import 'base64-sol/base64.sol';
import "./TunesMetadata.sol";


contract DerivedTune is ERC165, IERC721Metadata {
    

    IERC721Enumerable public tunes;
    TunesMetadata public tunesMetadata;

    address public metadataRegistryDevAddress;

    string private _name;
    string private _symbol;

    constructor(address tunesOfficialAddress, address tunesMetadataAddress, address devAddress, string memory name, string memory symbol) {
        tunes = IERC721Enumerable(tunesOfficialAddress);
        tunesMetadata = TunesMetadata(tunesMetadataAddress);
        metadataRegistryDevAddress = devAddress;
        _name = name;
        _symbol = symbol;
    }

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

    function isApprovedForAll(address owner, address operator) public override view returns (bool) {
        require(false, "DerivedTune is not a transferable");
        return false;
    }
    
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
