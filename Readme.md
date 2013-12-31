CoinWatch
=========

Coinwatch is quick-and-dirty DOGE/USD balance ticker.  The code's horrible, and it'll break if there's pretty much any network issues or a problem with any of the 4 sites it relies on.  In order to function, the script needs the following information

  - Cryptsy account w/API enabled
  - Suchcoins.com id and user token (Other MPOS-enabled pools may also be compatible, provided they support the getuserbalance action)
  - DOGE Wallet public key (**NOT** private)

I may clean up the code at some point and add additional features - we'll see