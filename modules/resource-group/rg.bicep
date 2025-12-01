targetScope = 'subscription'

param rgName string
param location string
param tags object

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
  tags: tags
}

output rgName string = rg.name



