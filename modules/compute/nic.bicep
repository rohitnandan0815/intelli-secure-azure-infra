param prefix string
param project string
param env string
param region string
param location string
param tags object
param pipId string
param subnetId string


var nicName = 'nic-${prefix}-${project}-${env}-${region}-01'

resource nic 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: nicName
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pipId
          }
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}

output nicId string = nic.id

