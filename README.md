### 部署

```shell
source .env
# SEPOLIA
forge script script/Deploy.s.sol --broadcast --rpc-url $SEPOLIA_HTTP_URL --private-key $PRIVATE_KEY --with-gas-price 200000000000
```