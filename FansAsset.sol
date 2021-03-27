// contracts/FansAsset.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract FansAsset is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("FansAsset", "FANS") {}

    function createAsset(address creator, string memory tokenURI)
        public
        returns (uint256)
    {
        if (_isUniqueAsset(tokenURI)){
            _tokenIds.increment();
    
            uint256 newItemId = _tokenIds.current();
            _mint(creator, newItemId);
            _setTokenURI(newItemId, tokenURI);
              
            return newItemId;
        }
        revert("Asset is not uqniue!");
    }
    
    function _isUniqueAsset(string memory tokenURI)
        private
        returns (bool){
            //perform some smart logic with tokenURI parsing, etc.
            return true;
        }
        
}
