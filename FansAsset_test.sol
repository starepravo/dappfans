// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "../contracts/FansAsset.sol";

contract FansAssetTest {
   
    FansAsset fansAssetToTest;
    address _adrAlice;
    address _adrBob;
    address _adrMike;
    address _adrCharlie;
    
    function beforeAll () public {
        fansAssetToTest = new FansAsset();
        
        _adrAlice = TestsAccounts.getAccount(0);
        _adrCharlie = TestsAccounts.getAccount(1);
        _adrBob = TestsAccounts.getAccount(2);
    }
    
   
    function checkAliceReleasesOwnAsset () public {
        uint256 _tokenId;
        
        _tokenId = fansAssetToTest.createAsset(_adrAlice,"http://s3.example/images.json");
        Assert.equal(fansAssetToTest.ownerOf(_tokenId), _adrAlice, "NFT token release for Alice has failed");
        Assert.notEqual(fansAssetToTest.ownerOf(_tokenId), _adrCharlie, "NFT token release for Alice belongs to Charlie");
    }
     
     function checkChangeOwnership() public {
         uint256  _tokenId; 
        
         _tokenId = fansAssetToTest.createAsset(_adrAlice,"http://s3.example/images.json");
         Assert.equal(fansAssetToTest.ownerOf(_tokenId), _adrAlice, "NFT token release for Alice has failed");
         //fansAssetToTest.safeTransferFrom(_adrAlice, _adrBob, _tokenId);
         //Assert.equal(fansAssetToTest.ownerOf(_tokenId), _adrBob, "NFT token transfer from Alice to Bob has failed: Bob didn't gain access to token");
         //Assert.notEqual(fansAssetToTest.ownerOf(_tokenId), _adrAlice, "NFT token transfer from Alice to Bob has failed: Alice still owns a token");
     }
     
     function checkViewPurchase() public {
         uint256  _tokenId; 
        
         _tokenId = fansAssetToTest.createAsset(_adrAlice,"http://s3.example/images.json");
         Assert.equal(fansAssetToTest.ownerOf(_tokenId), _adrAlice, "NFT token release for Alice has failed"); 
         
         fansAssetToTest.purchaseAssetAccess(_adrBob,_tokenId);
         Assert.equal(fansAssetToTest.ownerOf(_tokenId), _adrAlice, "NFT token no longer belong to Alice after purchase"); 
         Assert.notEqual(fansAssetToTest.ownerOf(_tokenId), _adrBob, "Bob gained ownership access to NFT token after purchase");
         
         //Assert.equal(fansAssetToTest.isPermitted(_adrBob, _tokenId), false, "Bob gained viewer access without purchase");
         Assert.equal(fansAssetToTest.isPermitted(_adrAlice, _tokenId), true, "Alice can't view own content");
         fansAssetToTest.purchaseAssetAccess(_adrBob, _tokenId);
         Assert.equal(fansAssetToTest.isPermitted(_adrBob, _tokenId), true, "Bob didn't gain viewer access after purchase");         
     }
    
    //function checkWinninProposalWithReturnValue () public view returns (bool) {
      //  return ballotToTest.winningProposal() == 0;
    //}
}
