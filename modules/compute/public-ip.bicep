param prefix string
param env string
param location string
param tags object

var pipName = 'pip-${prefix}-${env}-01'

resource publicIp 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: pipName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

output pipId string = publicIp.id

