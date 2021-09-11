//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC721Enumerable.sol";
import "@openzeppelin/contracts/interfaces/IERC721Metadata.sol";

contract TunesMetadata is Ownable {
    IERC721Enumerable public tunes = IERC721Enumerable(0xfa932d5cBbDC8f6Ed6D96Cc6513153aFa9b7487C);

    function getTokenOwner(uint tokenId) public view returns (address owner) {
        require (tokenId < tunes.totalSupply(), 'invalid tokenID');
        return tunes.ownerOf(tokenId);
    }

    struct OfficialMetadata {
        string key;
        address devAddress;
    }

    mapping(string => OfficialMetadata) public officialMetadata;
    string[] public officialMetadataAliases;
    
    mapping(address => mapping(string => mapping(uint => string))) public directMetadata;
    
    mapping(address => mapping(string => address)) public inheritedMetadata;

    function setOfficialMetadata(address _devAddress, string memory _key, string memory _metadataKeyAlias) public onlyOwner {
        OfficialMetadata storage officialMetadataInstance = officialMetadata[_metadataKeyAlias];
        
        // Only update the keys if this was never set
        if (bytes(officialMetadataInstance.key).length == 0) {
            officialMetadataAliases.push(_metadataKeyAlias);
        }

        officialMetadataInstance.devAddress = _devAddress;
        officialMetadataInstance.key = _key;
    }
    
    function getOfficialMetadata(string memory _metadataKeyAlias, uint _tokenID) public view returns (string memory) {
        OfficialMetadata memory officialMetadataInstance = officialMetadata[_metadataKeyAlias];
        return getMetadata(officialMetadataInstance.devAddress, officialMetadataInstance.key, _tokenID);
    }
    
    function getOfficialMetadataAliases() public view returns (string[] memory) {
        return officialMetadataAliases;
    }
    
    // First, check to see if there's a contract linked. Any inherited metadata always takes priority of metadata that is directly set.
    
    function getMetadata(address _devAddress, string memory _key, uint _tokenID) public view returns (string memory) {
        string memory metadata = getInheritedMetadata(_devAddress, _key, _tokenID);
        
        if (bytes(metadata).length > 0) {
            return metadata;
        }
        
        return directMetadata[_devAddress][_key][_tokenID];
    }
    
    // Direct Metadata - used to to directly set string values for a Tune.

    function setDirectMetadata(address _devAddress, string memory _key, uint _tokenID, string memory _data) public {
        require (msg.sender == _devAddress, 'You do not own this metadata collection.');
        directMetadata[_devAddress][_key][_tokenID] = _data;
    }
    
    // Inherited Metadata - used to set metadata for a Tune using the tokenURI of a deployed derivativeContract
    
    function getInheritedMetadata(address _devAddress, string memory _key, uint _tokenID) public view returns (string memory) {
        require (_tokenID < tunes.totalSupply(), 'invalid tokenID');
        IERC721Metadata derivativeContract = IERC721Metadata(inheritedMetadata[_devAddress][_key]);
        return derivativeContract.tokenURI(_tokenID);
    }

    function setInheritedMetadata(address _devAddress, string memory _key, address _address) public {
        require (msg.sender == _devAddress, 'You do not own this metadata collection.');
        require (inheritedMetadata[_devAddress][_key] == address(0), "You cannot replace this address.");
        inheritedMetadata[_devAddress][_key] = _address;
    }
}