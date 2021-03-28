// contracts/FansAsset.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract FansAsset is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(uint256 => mapping(address => bool)) private _viewPermissions;

    constructor() ERC721("FansAsset", "FANS") {}
    receive() external payable {}

    function createAsset(address creator, string memory tokenURI)
        public
        returns (uint256){
                
            if (_isUniqueAsset(tokenURI)){
                _tokenIds.increment();
        
                uint256 newItemId = _tokenIds.current();
                _mint(creator, newItemId);
                _setTokenURI(newItemId, tokenURI);
                
                _viewPermissions[newItemId][creator] = true;
                  
                return newItemId;
            }
            revert("Asset is not uqniue!");
    }
    
    function _isUniqueAsset(string memory tokenURI)
        private 
        pure
        returns (bool){
            //perform some smart logic with tokenURI parsing, etc.
            return bytes(tokenURI).length > 0;
        }
        
    function purchaseAssetAccess(address to, uint256 tokenId) 
        public{
            // add address to th elist of permitted viewers
            _viewPermissions[tokenId][to] = true;
        }
        
     function isPermitted(address to, uint256 tokenId)
        public
        view
        returns(bool){
            return _viewPermissions[tokenId][to];
        }
}
