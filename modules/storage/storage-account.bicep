param project string
param env string
param region string
param location string
param tags object
param skuName string
param kind string
param suffix string

var saName = 'stg${project}${env}${region}${suffix}'


resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: saName
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  kind: kind
}


