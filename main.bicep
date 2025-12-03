targetScope = 'subscription'

// ===== Parameters =====
param prefix string
param project string
param env string
param region string
param location string
param tags object 
param vnetAddress string
param subnets array
param adminUsername string
@secure()
param adminPassword string
param storageAccounts array
param vmList array
param nicList array

// ===== Naming =====
var rgName = 'rg-${prefix}-${project}-${env}'

// ===== Resource Group =====
module rg './modules/resource-group/rg.bicep' = {
  name: 'rg-deploy'
  params: {
    rgName: rgName
    location: location
    tags: tags
  }
}

// ===== VNET =====
module vnet './modules/network/vnet.bicep' = {
  name: 'vnet-deploy'
  scope: resourceGroup(rgName)
  dependsOn: [ rg ]
  params: {
    prefix: prefix
    project: project
    env: env
    region: region
    location: location
    tags: tags
    vnetAddress: vnetAddress
    subnets: subnets
  }
}

// ===== NIC LOOP =====
module nic './modules/compute/nic.bicep' = [for (nicItem, i) in nicList: {
  name: 'nic-${prefix}-${project}-${env}-${region}-${nicItem.nicIndex}'
  scope: resourceGroup(rgName)
  
  params: {
    prefix: prefix
    project: project
    env: env
    region: region
    location: location
    tags: tags
    subnetId: vnet.outputs.subnetIds[0]
    nicIndex: nicItem.nicIndex
  }
}]

// ===== VM LOOP =====
module linuxVm './modules/compute/linux-vm.bicep' = [for (vm, i) in vmList: {
  name: 'vm-linux-${prefix}-${project}-${env}-${vm.suffix}'
  scope: resourceGroup(rgName)
  dependsOn: [ nic ]
  params: {
    prefix: prefix
    project: project
    env: env
    region: region
    location: location
    tags: tags
    nicId: nic[i].outputs.nicId
    adminUsername: adminUsername
    adminPassword: adminPassword
    vmSize: vm.size
    suffix: vm.suffix
  }
}]

// ===== STORAGE Loop =====
module storage './modules/storage/storage-account.bicep' = [for sa in storageAccounts: {
  name: 'storage-${project}-${env}-${sa.suffix}'
  scope: resourceGroup(rgName)
  dependsOn: [ rg ]
  params: {
    project: project
    env: env
    region: sa.region
    location: location
    tags: tags
    skuName: sa.skuName
    kind: sa.kind
    suffix: sa.suffix
  }
}]

output resourceGroupName string = rgName

