@description('(Optional, Existing Subnet to deploy the container instance to.')
param vnetRg string
param vnetName string = 'ado-vnet'
param SubnetName string ='agentSubnet'

@description('Location for all resources.')
param location string = resourceGroup().location
@description('Name for the container group')
param aciGroupName string
@description('Container image server url')
param imageServer string 
@description('Container image to deploy.')
param image string
@description('The number of CPU cores to allocate to the container.')
param cpuCores int = 1
@description('The amount of memory to allocate to the container in gigabytes.')
param memoryInGb int = 2
@description('OS type')
@allowed(['Linux'])
 param osType string 
@description('The behavior of Azure runtime if container has stopped.')
@allowed([
  'Always'
  'Never'
  'OnFailure'
])
param restartPolicy string = 'Always'
@description('Number of linux container instances deploy. DO NOT CHANGE THIS VALUE, Change instance count in pipeline variables')
param instances int = 1
@description('Container environment variables. Array of name, value|secureValue')
param environmentVariables array
@description('Resource tags')
param tags object = { Application: 'self-hosted' }
@description('Custom DNS servers to use for private DNS. Array of strings holding IP address of DNS servers.')
param dnsServers array

@description('Container image server Username')
param spId string 
@secure()
param spPwd string 

var containerPrefix = 'selfhosted-lnx-'
var envVariables = [for e in environmentVariables: {
  name: e.name
  value: contains(e, 'value') ? e.value : null
  secureValue: contains(e, 'secureValue') ? e.secureValue : null
}]

resource VNET 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetRg)
}

resource Subnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' existing = {
  name: SubnetName
  parent: VNET
}

resource containerGroupResource 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = {
  name: aciGroupName
  location: location
  tags: tags
  properties: {
    containers: [for index in range(0, instances): {
      name: '${containerPrefix}${aciGroupName}${padLeft(index + 1, 3, '0')}'
      properties: {
        image: '${imageServer}/${image}'
        environmentVariables: concat(envVariables, [
            {
              name: 'NAME'
              value: '${containerPrefix}${aciGroupName}${padLeft(index + 1, 2, '0')}'
            }
          ])
        resources: {
          requests: {
            cpu: cpuCores
            memoryInGB: memoryInGb
          }
        }
      }
    }
  ]
    dnsConfig: empty(dnsServers) ? null : {
      nameServers: dnsServers
    }

    imageRegistryCredentials: [
      {
        server: imageServer
        username: spId
        password: spPwd
      }
    ]

    osType: osType
    restartPolicy: restartPolicy
    subnetIds: [
      {
        id: Subnet.id
      }
    ]
  }
}

      
        // identity: identityId 
