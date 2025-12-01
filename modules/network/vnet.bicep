param prefix string
param project string
param env string
param region string
param location string
param tags object
param vnetAddress string
param subnets array

var vnetName = 'vnet-${prefix}-${project}-${env}-${region}-01'

resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddress
      ]
    }
    subnets: [
      for subnet in subnets: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.addressPrefix
        }
      }
    ]
  }
}

output vnetName string = vnet.name
output vnetId string = vnet.id
output subnetIds array = [
  for s in subnets: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, s.name)
]



