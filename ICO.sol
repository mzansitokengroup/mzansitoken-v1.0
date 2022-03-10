// Offical ICO smart contract for The MzansiToken ERC-20
// Overall idea: Basically allows investers to purchase tokens in an
initial coin offering (ICO).
//This code belongs to TITLED Conglomerate PTY LTD for the MzansiToken v1.0 ERC-20 Token 

pragma solidity ^0.4.2;

import "./DappToken.sol";

contract MzansiTokenSale {
    address admin;			// This stores the admin account for the crowdsale itself
    MzansiToken public tokenContract;	//This references the ERC-20 token smart contract 
    uint256 public tokenPrice;		// This stores the Mzansi Token price
    uint256 public tokensSold;		// This stores the number of Tokens sold

    event Sell(address _buyer, uint256 _amount);	// this implements a "sell" event so that people who buy will get notifications whenever a token has been sold

    function MzansiTokenSale(MzansiToken _tokenContract, uint256 _tokenPrice) public {
        admin = msg.sender;
        tokenContract = _tokenContract;
        tokenPrice = _tokenPrice;
    }

    function multiply(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    function buyTokens(uint256 _numberOfTokens) public payable {	// This function allows users to purchase tokens in the crowd sale
        require(msg.value == multiply(_numberOfTokens, tokenPrice));
        require(tokenContract.balanceOf(this) >= _numberOfTokens);
        require(tokenContract.transfer(msg.sender, _numberOfTokens));

        tokensSold += _numberOfTokens;

        Sell(msg.sender, _numberOfTokens);
    }

    function endSale() public {			// This function allows the admin to end the crowdsale and collect the Ether funds that will be raised during the sale
        require(msg.sender == admin);
        require(tokenContract.transfer(admin, tokenContract.balanceOf(this)));

        // Just transfer the balance to the admin
        admin.transfer(address(this).balance);
    }
}
