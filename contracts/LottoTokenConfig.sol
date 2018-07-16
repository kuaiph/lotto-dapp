pragma solidity ^0.4.0;

contract LottoTokenConfig {

    string  public constant symbol      = "LTT";
    string  public constant name        = "Lotto Token";
    uint8   public constant decimals    = 18;

    uint256 public constant DECIMALSFACTOR    = 10**uint256(decimals);
    uint256 public constant INITIAL_SUPPLY = 200000000 * DECIMALSFACTOR;
}

