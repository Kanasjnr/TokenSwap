// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.27;

import {IERC20} from "./IToken.sol";

contract SwapToken {
    IERC20 public KanasToken;
    IERC20 public JnrToken;
    uint256 public exchangeRate;

    event SwapKanas(
        address indexed user,
        uint256 KanasAmount,
        uint256 JnrAmount
    );
    event SwapJnr(
        address indexed user,
        uint256 JnrAmount,
        uint256 KanasAmount
    );

    event TokensDeposited(
        address indexed depositor,
        uint256 KanasAmount,
        uint256 JnrAmount
    );

    constructor(address _KanasToken, address _JnrToken, uint256 _exchangeRate) {
        KanasToken = IERC20(_KanasToken);
        JnrToken = IERC20(_JnrToken);
        exchangeRate = _exchangeRate;
    }

    function SwapKanasToJnr(uint256 _amount) public {
        require(msg.sender != address(0), "Not allowed");
        uint256 JnrAmount = _amount * exchangeRate;
        require(
            JnrToken.balanceOf(address(this)) >= JnrAmount,
            "Not enough Jnr Token"
        ); 

        require(
            KanasToken.transferFrom(msg.sender, address(this), _amount),
            "Kanas transfer failed"
        );

        require(
            JnrToken.transfer(msg.sender, JnrAmount),
            "Jnr transfer failed"
        );
        emit SwapKanas(msg.sender, _amount, JnrAmount);
    }

    function SwapJnrToKanas(uint256 _amount) public {
        require(msg.sender != address(0), "Not allowed");

        uint256 KanasAmount = _amount / exchangeRate; 
        require(
            KanasToken.balanceOf(address(this)) >= KanasAmount,
            "Not enough Jnr amount"
        ); 

        require(
            JnrToken.transferFrom(msg.sender, address(this), _amount),
            "Kanas transfer failed"
        );

        require(
            KanasToken.transfer(msg.sender, KanasAmount),
            "Base transfer failed"
        );
        emit SwapJnr(msg.sender, _amount, KanasAmount);
    }

    function depositTokens(uint256 KanasAmount, uint256 JnrAmount) public {
        KanasToken.transferFrom(msg.sender, address(this), KanasAmount);
        JnrToken.transferFrom(msg.sender, address(this), JnrAmount);

        emit TokensDeposited(msg.sender, KanasAmount, JnrAmount);
    }
}

