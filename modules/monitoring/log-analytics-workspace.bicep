param project string
param env string
param region string
param location string
param tags object

var workspaceName = 'law-${project}-${env}-${region}-01'

resource log 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: workspaceName
  location: location
  tags: tags
  properties: {}
}

output lawId string = log.id
