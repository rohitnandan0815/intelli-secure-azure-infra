param prefix string
param project string
param env string
param region string
param location string
param tags object
param subnetId string
param nicIndex string

resource nic 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: 'nic-${prefix}-${project}-${env}-${region}-${nicIndex}'
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}

output nicId string = nic.id

