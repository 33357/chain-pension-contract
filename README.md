### 部署

```shell
source .env
# SEPOLIA
forge script script/Deploy.s.sol --broadcast --private-key $PRIVATE_KEY --rpc-url $SEPOLIA_HTTP_URL --with-gas-price 200000000000 --verify

forge verify-contract --chain-id 11155111 0x5000481cbfE536fe74f77C21C3e7E4d387C92B5a src/Persion.sol:Persion --etherscan-api-key $ETHERSCAN_API_KEY
```