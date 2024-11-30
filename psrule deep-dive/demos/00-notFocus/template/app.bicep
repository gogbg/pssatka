targetScope = 'resourceGroup'

param location string
param vnetName string
param vnetAddressRange string
param subnet1Name string
param subnet1AddressRange string
param subnet2Name string
param subnet2AddressRange string
param storageAccountName string
param containerInstanceName string
param containerInstanceImage string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-03-01' = {
   name: vnetName
   location: location
   properties: {
      addressSpace: {
         addressPrefixes: [
            vnetAddressRange
         ]
      }
   }
   resource subnet1 'subnets@2024-03-01' = {
      name: subnet1Name
      properties: {
         addressPrefix: subnet1AddressRange
         delegations: [
            {
               name: 'myDelegation'
               properties: {
                  serviceName: 'Microsoft.ContainerInstance/containerGroups'
               }
            }
         ]
      }
   }
   resource subnet2 'subnets@2024-03-01' = {
      name: subnet2Name
      properties: {
         addressPrefix: subnet2AddressRange
      }
   }
}

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
   name: storageAccountName
   location: location
   kind: 'StorageV2'
   sku: {
      name: 'Premium_LRS'
   }
   properties: {
      networkAcls: {
         defaultAction: 'Allow'
      }
   }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
   name: 'pe-${storageAccountName}-${subnet1Name}'
   location: location
   properties: {
      privateLinkServiceConnections: [
         {
            name: 'default'
            properties: {
               privateLinkServiceId: storageaccount.id
               groupIds: [
                  'blob'
               ]
            }
         }
      ]
      subnet: {
         id: virtualNetwork::subnet2.id
      }
   }
}

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = {
   name: containerInstanceName
   location: location
   properties: {
      containers: [
         {
            name: containerInstanceName
            properties: {
               image: containerInstanceImage
               resources: {
                  requests: {
                     cpu: 1
                     memoryInGB: 2
                  }
               }
               ports: [
                  { port: 443, protocol: 'TCP' }
                  { port: 80, protocol: 'TCP' }
               ]
            }
         }
      ]
      restartPolicy: 'Never'
      osType: 'Linux'
      ipAddress: {
         type: 'Private'
         ports: [
            {
               protocol: 'TCP'
               port: 80
            }
            {
               protocol: 'TCP'
               port: 443
            }
         ]
      }
      subnetIds: [
         {
            name: virtualNetwork::subnet1.name
            id: virtualNetwork::subnet1.id
         }
      ]
   }
}
