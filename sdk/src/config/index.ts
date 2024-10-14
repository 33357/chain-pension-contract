export interface ContractInfo {
  proxyAddress: string;
  implAddress: string;
  version: string;
  operator: string;
  fromBlock: number;
}

export interface Deployment {
  [chainId: number]: {
    [contractName: string]: ContractInfo;
  };
}

import * as deploymentData from './deployment.json';
export const DeploymentInfo: Deployment = deploymentData;
