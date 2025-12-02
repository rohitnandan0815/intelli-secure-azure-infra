// param prefix string
// param project string
// param env string
// param region string
// param location string
// param tags object
// param nicIndex string

// var pipName = 'pip-${prefix}-${project}-${env}-${region}-${nicIndex}'

// resource publicIp 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
//   name: pipName
//   location: location
//   tags: tags
//   sku: {
//     name: 'Standard'
//   }
//   properties: {
//     publicIPAllocationMethod: 'Static'
//   }
// }

// output pipId string = publicIp.id
