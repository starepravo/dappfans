// contracts/FansAsset.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract FansAsset is ERC721Enumerable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(uint256 => mapping(address => uint)) private _viewPays;
    // amount of sales on specific token
    mapping(uint256 => uint256) private _tokenSales;

    constructor() ERC721("FansAsset", "FANS") {}
    receive() external payable {}

    function createAsset(address creator, string memory tokenURI)
        public
        returns (uint256){
                
            if (_isUniqueAsset(tokenURI)){
                _tokenIds.increment();
        
                uint256 newItemId = _tokenIds.current();
                _mint(creator, newItemId);
                
                //TODO: figure out multiple inheritence
                //_setTokenURI(newItemId, tokenURI);
                
                _tokenSales[newItemId] = 0;
                
                return newItemId;
            }
            revert("Asset is not uqniue!");
    }
    
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
        
    }
    
    function _isUniqueAsset(string memory tokenURI)
        private 
        pure
        returns (bool){
            //perform some smart logic with tokenURI parsing, etc.
            return bytes(tokenURI).length > 0;
        }
        
    function purchaseAssetAccess(address to, uint256 tokenId) 
        external payable{
            // add address to th elist of permitted viewers
           _viewPays[tokenId][to] = msg.value;
           
           _tokenSales[tokenId] += msg.value;
        }
        
     function isPermitted(address to, uint256 tokenId)
        public
        view
        returns(bool){
            return _isApprovedOrOwner(to, tokenId) || _viewPays[tokenId][to] > 0;
        }
        
    function getCreatorRating(address creator)
        public
        view
        returns(uint256){
        
        uint256 creatorRating = 0;
        uint tokensNum = balanceOf(creator);
        for( uint i=0; i < tokensNum; i++){
            uint256 tokenId = tokenOfOwnerByIndex(creator, i);
            creatorRating += _tokenSales[tokenId];
        }
         
        return creatorRating;   
        
    }
}
