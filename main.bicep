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




// ===== Naming Conventions =====
var rgName = 'rg-${prefix}-${project}-${env}'


// ===== Resource Group Module =====
module rg './modules/resource-group/rg.bicep' = {
  name: 'rg-deploy'
  params: {
    rgName: rgName
    location: location
    tags: tags
  }
}

// ===== VNET Module =====
module vnet './modules/network/vnet.bicep' = {
  name: 'vnet-deploy'
  scope: resourceGroup(rgName)
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


// ===== Public IP =====
module pip './modules/compute/public-ip.bicep' = {
  name: 'pip-${prefix}-${env}-01'
  scope: resourceGroup(rgName)
  params: {
    prefix: prefix
    env: env
    location: location
    tags: tags
  }
}

// ===== NIC =====
module nic './modules/compute/nic.bicep' = {
  name: 'nic-${prefix}-${env}-01'
  scope: resourceGroup(rgName)
    params: {
    prefix: prefix
    project: project
    env: env
    region: region       
    location: location
    tags: tags
    pipId: pip.outputs.pipId
    subnetId: vnet.outputs.subnetIds[0]
  }

}
// ===== LINUX VM LOOP ======

module linuxVm './modules/compute/linux-vm.bicep' = [for vm in vmList: {
  name: 'vm-linux-${prefix}-${project}-${env}-${vm.suffix}'
  scope: resourceGroup(rgName)
  params: {
    prefix: prefix
    project: project
    env: env
    region: region
    location: location
    tags: tags
    nicId: nic.outputs.nicId
    adminUsername: adminUsername
    adminPassword: adminPassword
    vmSize: vm.size
    suffix: vm.suffix
  }
}]


// ===== STORAGE ACCOUNTS LOOP =====
module storage './modules/storage/storage-account.bicep' = [for sa in storageAccounts: {
  name: 'storage-${project}-${env}-${sa.suffix}'
  scope: resourceGroup(rgName)
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
