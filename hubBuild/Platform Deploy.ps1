#External Paramters Collection
$platformName = Read-host -prompt "Enter the name of the hub"
$tagSalesOrderId  =  Read-Host -Prompt "Enter the Sale Order ID of the customer solution"
$tagCostCentreId  =  Read-Host -Prompt "Enter the Cost Centre ID of the solution"
$hubUksPrefix = Read-host -Prompt "Enter the IP Range allocated for Platform Infrastructure in UK South:"
$lowerHubNetThirdOctetUks = Read-host -Prompt "Enter Lower three IP octets for hub in UK South"
$upperHubNetThirdOctetUks =Read-host -Prompt "Enter Upper three  IP octets for hub in UK South"
$hubUkwPrefix = Read-host -Prompt "Enter the IP Range allocated for Platform Infrastructure in UK West:"
$lowerHubNetThirdOctetUkw = Read-host -Prompt "Enter Lower three IP octets for hub in UK West"
$upperHubNetThirdOctetUkw =Read-host -Prompt "Enter Upper three IP octets for hub in UK West"
$customerDevUatDesktopPrefix = Read-host -Prompt "Enter the IP Range allocated for Customer  Development/UAT desktops"
$customerDevUatInfrastructurePrefix = Read-host -Prompt "Enter the IP Range allocated for Customer Development/UAT Infrastructure"


#Resource Group variables
$hubUksResourceGroupName = $platformName + "ukshubrg01"
$custDevUATUksResourceGroupName = $platformName + "uksdevuatrg01"
$hubUkwResourceGroupName = $platformName + "ukwhubrg01"

#Log analytics and Automation Variables
$hubLawName = $platformName + "hublaw01"
$hubaaName = $platformName + "hubaa01"

#Platform Hub UK South Virtual Network Variables
$hubuksVnetName = $platformName + "ukshubvnet01"
$hubUksSharedServicesSubnetRange = $upperHubNetThirdOctetUks + ".0/24"
$hubUksDomainServicesSubnetRange = $lowerHubNetThirdOctetUks + ".0/28"
$hubUksDmzSubnetRange = $lowerHubNetThirdOctetUks + ".64/27"

$hubUksGatewayServicesSubnetRange = $lowerHubNetThirdOctetUks + ".32/27"
$hubUksAzureFirewallSubnetRange= $lowerHubNetThirdOctetUks + ".128/26"
$hubUksDc01VmIp = $lowerHubNetThirdOctetUks + ".4"
$hubUksDc02VmIp = $lowerHubNetThirdOctetUks + ".5"
$hubUksMgmt01VmIp = $upperHubNetThirdOctetUks + ".4"

##Platford Hub UK South NSG Variables
$hubUksNsgName = $platformName + "ukshubnsg01"
##Platford Hub UK West NSG Variables
$hubUkwNsgName = $platformName + "ukwhubnsg01"




#Platform Hub UK West Virtual Network Variables
$hubukwVnetName = $platformName + "ukwhubvnet01" 
$hubUkwSharedServicesSubnetRange = $upperHubNetThirdOctetUkw + ".0/24"
$hubUkwDomainServicesSubnetRange = $lowerHubNetThirdOctetUkw + ".0/28"
$hubUkwDmzSubnetRange = $lowerHubNetThirdOctetUkw + ".64/27"
$hubUkwGatewayServicesSubnetRange = $lowerHubNetThirdOctetUkw + ".32/27"
$hubUkwAzureFirewallSubnetRange= $lowerHubNetThirdOctetUkw + ".128/26"
$hubUkwDc01VmIp = $lowerHubNetThirdOctetUkw + ".4"
$hubUkwDc02VmIp = $lowerHubNetThirdOctetUkw + ".5"
$hubUkwMgmt01VmIp = $upperHubNetThirdOctetUks + ".4"


#Platform Hub UK South Diagnostic Storage Variables
$hubUksDsaName = $platformName + "ukshubdsa01" 

#Platform Hub UK West Diagnostic Storage Variables
$hubUkwDsaName = $platformName + "ukwhubdsa01" 



#Platform Hub UK South Public IP Address variables
$hubUksFirewallPipName = $platformName + "ukshubafw01pip"
$hubUksVngPipName01 = $platformName + "ukshubvng01pip"
$hubUksVngPipName02 = $platformName + "ukshubvng02pip"

#Platform Hub UK West Public IP Address variables
$hubUkwFirewallPipName = $platformName + "ukwhubafw01pip"
$hubUkwVngPipName01 = $platformName + "ukwhubvng01pip"
$hubUkwVNGPipName02 = $platformName + "ukwhubvng02pip"






$hubKvName = $platformName + "hubkv01" 








##Connect to Azure
#Connect-AzAccount



##Parameters to pass to Arm Templates
#Log Analytics and Automation Build parameters
$lawBuildParameters = @{
  'hubLawName' = [string] $hubLawName
  'hubAaName' =  [string] $hubAaName
  'location' = [string] "uksouth"
  'tagCostCentreId' =  [string] $tagCostCentreId
  'tagSalesOrderId' =  [string] $tagSalesOrderId
}

#UK South Hub NSG Build Parameters
$nsgUksBuildParameters = @{
  'hubNsgName' = [string]  $hubUksNsgName
  'location' = "uksouth"
  'tagCostCentreId' =  [string] $tagCostCentreId
  'tagSalesOrderId' =  [string] $tagSalesOrderId
  'hubMgmt01VmIp' =  [string] $hubUksMgmt01VmIp
  'customerDesktopNetwork' =  [string] $customerDevUatDesktopPrefix
  'hubDmzSubnetRange' = [string] $hubUksDmzSubnetRange
  'hubSharedServicesSubnetRange' = [string] $hubUksSharedServicesSubnetRange
  'hubUksDc01VmIp' =  [string] $hubUksDc01VmIp
  'hubUksDc02VmIp' =  [string] $hubUksDc02VmIp
  'hubUkwDc01VmIp' =  [string] $hubUkwDc01VmIp
  'hubUkwDc02VmIp' =  [string] $hubUkwDc02VmIp
}






#UK West Hub NSG Build Parameters
$nsgUkwBuildParameters = @{
  'hubNsgName' = [string]  $hubUkwNsgName
  'location' = "ukwest"
  'tagCostCentreId' =  [string] $tagCostCentreId
  'tagSalesOrderId' =  [string] $tagSalesOrderId
  'hubUksDc01VmIp' =  [string] $hubUksDc01VmIp
  'hubUksDc02VmIp' =  [string] $hubUksDc02VmIp
  'hubUkwDc01VmIp' =  [string] $hubUkwDc01VmIp
  'hubUkwDc02VmIp' =  [string] $hubUkwDc02VmIp
  'hubMgmt01VmIp' =  [string] $hubUkwMgmt01VmIp
  'hubSharedServicesSubnetRange' = [string] $hubUkwSharedServicesSubnetRange
  'customerDesktopNetwork' =  [string] $customerDevUatDesktopPrefix
  'hubDmzSubnetRange' = [string] $hubUkwDmzSubnetRange

}

#UK South Hub Virtual network Build Parameters
$vnetUksBuildParameters = @{
  'hubVnetName' = [string] $hubuksVnetName
  'hubIpPrefix' = [string] $hubUksPrefix
  'hubSharedServicesSubnetRange' = [string] $hubUksSharedServicesSubnetRange
  'hubDomainServicesSubnetRange' = [string] $hubUksDomainServicesSubnetRange
  'hubDmzSubnetRange' = [string] $hubUksDmzSubnetRange
  'hubGatewayServicesSubnetRange' = [string] $hubUksGatewayServicesSubnetRange
  'hubAzureFirewallSubnetRange'  = [string] $hubUksAzureFirewallSubnetRange
  'hubDc01VmIp' =  [string] $hubUksDc01VmIp
  'hubDc02VmIp' =  [string] $hubUksDc02VmIp
  'location' = "uksouth"
  'tagCostCentreId' =  [string] $tagCostCentreId
  'tagSalesOrderId' =  [string] $tagSalesOrderId
  'hubNsgName' = [string]  $hubUksNsgName
}

  
  
#UK West Hub Virtual network Build Parameters
$vnetUkwBuildParameters = @{
  'hubVnetName' = [string] $hubukwVnetName
  'hubIpPrefix' = [string] $hubUkwPrefix
  'hubSharedServicesSubnetRange' = [string] $hubUkwSharedServicesSubnetRange
  'hubDomainServicesSubnetRange' = [string] $hubUkwDomainServicesSubnetRange
  'hubDmzSubnetRange' = [string] $hubUkwDmzSubnetRange
  'hubGatewayServicesSubnetRange' = [string] $hubUkwGatewayServicesSubnetRange
  'hubAzureFirewallSubnetRange'  = [string] $hubUkwAzureFirewallSubnetRange
  'hubDc01VmIp' =  [string] $hubUkwDc01VmIp
  'hubDc02VmIp' =  [string] $hubUkwDc02VmIp
  'location' = "ukwest"
  'tagCostCentreId' =  [string] $tagCostCentreId
  'tagSalesOrderId' =  [string] $tagSalesOrderId
  'hubNsgName' = [string]  $hubUkwNsgName

  
  
}
#KeyVault Build Parameters
#$kvBuildParameters = @{
#  'hubKvName' = [string] $hubKvName
#  'tagCostCentreId' =  [string] $tagCostCentreId
#  'tagSalesOrderId' =  [string] $tagSalesOrderId
#}
#Diagnostics Storage Build Parameters
$dsaUksBuildParameters = @{
  'storageAccountName' = [string] $hubUksDsaName
  'location' = [string] "uksouth"
  'tagCostCentreId' =  [string] $tagCostCentreId
  'tagSalesOrderId' =  [string] $tagSalesOrderId

}

$dsaUkwBuildParameters = @{
  'storageAccountName' = [string] $hubUkwDsaName
  'location' = [string] "ukwest"
  'tagCostCentreId' =  [string] $tagCostCentreId
  'tagSalesOrderId' =  [string] $tagSalesOrderId

}
$pipUksBuildParameters = @{
  'HubFirewallPipName' = [string]  $hubUksFirewallPipName
  'location' = "uksouth"
  'tagCostCentreId' =  [string] $tagCostCentreId
  'tagSalesOrderId' =  [string] $tagSalesOrderId
  'hubVngPipName01' =  [string] $hubUksVngPipName01
  'hubVngPipName02' =  [string] $hubUksVngPipName02
}
$pipUkwBuildParameters = @{
  'HubFirewallPipName' = [string]  $hubUkwFirewallPipName
  'location' = "ukwest"
  'tagCostCentreId' =  [string] $tagCostCentreId
  'tagSalesOrderId' =  [string] $tagSalesOrderId
  'hubVngPipName01' =  [string] $hubUkwVngPipName01
  'hubVngPipName02' =  [string] $hubUkwVngPipName02
}

#Deploy new Platform Hub resource group in both UK South and UK West Azure DataCentres
New-AzResourceGroup -Name $hubUksResourceGroupName  -Location uksouth `
    -Tags @{Owner="Blocksolutions";Department ="Workspace and Cloud";Environment ="Production"; CostCentre =$tagCostCentreId; Location = "UK South"; SalesOrderID =$tagSalesOrderId}
New-AzResourceGroup -Name $hubUkwResourceGroupName  -Location ukwest `
    -Tags @{Owner="Blocksolutions";Department ="Workspace and Cloud";Environment ="Production"; CostCentre =$tagCostCentreId; Location = "UK West"; SalesOrderID =$tagSalesOrderId}

#Deploy new Customer Dev and UAT resource group in UK South Azure DataCentre only
New-AzResourceGroup -Name $custDevUATUksResourceGroupName -Location uksouth `
    -Tags @{Owner="Blocksolutions";Department ="Workspace and Cloud";Environment ="UAT and Dev"; CostCentre =$tagCostCentreId; SalesOrderID =$tagSalesOrderId}

#Deploy Log analytics workspace into Platform Hub in UK South Azure DataCentre
New-AzResourceGroupDeployment -ResourceGroupName $hubUksResourceGroupName `
-TemplateFile C:\Users\bjowett\Documents\Development\WVD\hubBuild\Common\Services\Hub-LAW.json `
-TemplateParameterObject $lawBuildParameters

#Deploy new Platform hub NSG in UK South and UK West Azure DataCentres
New-AzResourceGroupDeployment -ResourceGroupName $hubUksResourceGroupName `
-TemplateFile C:\Users\bjowett\Documents\Development\WVD\hubBuild\Common\Network\Hub-NSG.json `
-TemplateParameterObject $nsgUksBuildParameters
New-AzResourceGroupDeployment -ResourceGroupName $hubUkwResourceGroupName `
-TemplateFile C:\Users\bjowett\Documents\Development\WVD\hubBuild\Common\Network\Hub-NSG.json `
-TemplateParameterObject $nsgUkwBuildParameters

#Deploy new Platform hub virtual Network in UK South and UK West Azure DataCentres
New-AzResourceGroupDeployment -ResourceGroupName $hubUksResourceGroupName `
-TemplateFile C:\Users\bjowett\Documents\Development\WVD\hubBuild\Common\Network\Hub-VNET.json `
-TemplateParameterObject $vnetUksBuildParameters
New-AzResourceGroupDeployment -ResourceGroupName $hubUkwResourceGroupName `
-TemplateFile C:\Users\bjowett\Documents\Development\WVD\hubBuild\Common\Network\Hub-VNET.json `
-TemplateParameterObject $vnetUkwBuildParameters


##Deploy Hub Storage Account for Diagnostics within UK South and UK West DataCentre 
New-AzResourceGroupDeployment -ResourceGroupName $hubUksResourceGroupName `
-TemplateFile C:\Users\bjowett\Documents\Development\WVD\hubBuild\Common\Storage\Hub-DSA.json `
-TemplateParameterObject $dsaUksBuildParameters
New-AzResourceGroupDeployment -ResourceGroupName $hubUkwResourceGroupName `
-TemplateFile C:\Users\bjowett\Documents\Development\WVD\hubBuild\Common\Storage\Hub-DSA.json `
-TemplateParameterObject $dsaUkwBuildParameters




#Deploy Public IP Addresses within UK South and UK West Datacentres
New-AzResourceGroupDeployment -ResourceGroupName $hubUksResourceGroupName `
-TemplateFile C:\Users\bjowett\Documents\Development\WVD\hubBuild\Common\Network\Hub-PIP.json `
-TemplateParameterObject $pipUksBuildParameters
New-AzResourceGroupDeployment -ResourceGroupName $hubUkwResourceGroupName `
-TemplateFile C:\Users\bjowett\Documents\Development\WVD\hubBuild\Common\Network\Hub-PIP.json `
-TemplateParameterObject $pipUkwBuildParameters










#
 
