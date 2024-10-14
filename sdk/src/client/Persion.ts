import { Provider } from '@ethersproject/providers';
import { Signer } from 'ethers';
import { Persion, Persion__factory } from '../typechain';
import { DeploymentInfo } from '../config';

export class PersionClient {
  public contract: Persion;
  protected _provider: Provider | Signer;

  constructor(provider: Provider | Signer, chainId: number) {
    this._provider = provider;
    if (!DeploymentInfo[chainId].Persion) {
      throw 'no address';
    }
    this.contract = Persion__factory.connect(
      DeploymentInfo[chainId].Persion.proxyAddress,
      provider
    );
  }
}
