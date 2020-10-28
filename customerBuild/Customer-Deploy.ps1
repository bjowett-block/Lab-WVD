$tagCustomerName =  Read-Host -Prompt "Enter the Name of the customer with no spaces:" 
$tagSalesOrderId  =  Read-Host -Prompt "Enter the Sale Order ID of the customer solution:" 
$customerDesktopPrefix = Read-host -Prompt "Enter the IP Range allocated for customer desktops"
$customerInfrastructurePrefix = Read-host -Prompt "Enter the IP Range allocated for customer Infrastructure"
$customerRuleId001 = Read-Host -Prompt "Enter the ruleid for the Customer to ADDS-TCP:"
$customerRuleId002 = Read-Host -Prompt "Enter the ruleid for the Customer to ADDS-UDP"
$customerRuleId003 = Read-Host -Prompt "Enter the ruleid for the Customer to Internal KMS:"
$hubName = "pcwhub"
$hubResourceGroupName = $hubName + "rg01"
$hubFirewallGatewayIp = '172.18.0.132'
$customerDesktopPrefixName = $tagCustomerName + "-Desktop-Prefix"
$customerInfrastructurePrefixName = $tagCustomerName + "-Infrastructure-Prefix"
$customerRuleName001 = $tagCustomerName  + "-Allow-to-ADDS-TCP-In"
$customerRuleName002 = $tagCustomerName  + "-Allow-to-ADDS-UDP-In"
$customerRuleName003 = $tagCustomerName  + "-Allow-to-Mgmtkms-TCP-In"
$sourceIpAddress = @($customerDesktopPrefix , $customerInfrastructurePrefix)
$addsIpAddress = @('172.18.0.4' ,'172.18.0.5')
$addsTcpPorts = @('53','88','135','139','389','445','464','636','3268','3269','49152-65535')
$addsUdpPorts = @('53','88','389','464','123','636','3268','3269')
$customerResourceGroupName = $tagCustomerName + "rg01"
$hubrt01Name = $hubName + "rt01"
$hubrt02Name = $hubName + "rt02"
$hubdeskIpgName = $hubName + "custdkipg01"
$hubInfraIpgName = $hubName + "custinfraipg01"
$hubNsgName = $hubName + "nsg01"

##Connect to Azure
##Connect-AzAccount



##Parameters to pass to Arm Templates
$custBuildParameters = @{
  'hubName' = [string] $hubName
  'tagCustomerName' =  [string] $tagCustomerName 
  'tagSalesOrderId' =  [string] $tagSalesOrderId 
  'customerDesktopPrefix' =  [string]$customerDesktopPrefix
  'customerInfrastructurePrefix' =  [string] $customerInfrastructurePrefix
}


$vnetBuildParameters = @{
'hubName' = [string] $hubName
'tagCustomerName' =  [string] $tagCustomerName 

}

#Deploy new customer resource group
New-AzResourceGroup -Name $customerResourceGroupName -Location uksouth `
    -Tags @{Owner="Blocksolutions"; CustomerName =$tagCustomerName;Department ="Workspace and Cloud";Environment ="Production"; CostCentre ="PCW"; SalesOrderID =$tagSalesOrderId}

#Deploy new customer Azure infrastructure
 New-AzResourceGroupDeployment -ResourceGroupName $customerResourceGroupName `
    -TemplateFile C:\Users\bjowett\Documents\Development\WVD\customerBuild\Common\Customer-Deploy.json `
    -TemplateParameterObject $custBuildParameters

#Establish VNET Peer between Hub and Spoke
  New-AzResourceGroupDeployment -ResourceGroupName $hubResourceGroupName `
    -TemplateFile C:\Users\bjowett\Documents\Development\WVD\customerBuild\Common\Network\CustHub-DeployVnetPeer.json `
    -TemplateParameterObject $vnetBuildParameters


#Adding Spoke Routes to Hub Routing tables

#$routeTable = Get-AzRouteTable -ResourceGroupName $hubResourceGroupName  -Name $hubrt01Name
#Add-AzRouteConfig -Name $customerDesktopPrefixName `
  # -AddressPrefix $customerDesktopPrefix `
  # -NextHopType "VirtualAppliance" `
  # -NextHopIpAddress $hubFirewallGatewayIp `
  # -RouteTable $routeTable

 #Add-AzRouteConfig -Name $customerInfrastructurePrefixName `
  # -AddressPrefix $customerInfrastructurePrefix `
  # -NextHopType "VirtualAppliance" `
  # -NextHopIpAddress $hubFirewallGatewayIp `
  # -RouteTable $routeTable
 #Set-AzRouteTable -RouteTable $routeTable


#$routeTable = Get-AzRouteTable -ResourceGroupName $hubResourceGroupName  -Name $hubrt02Name
#Add-AzRouteConfig -Name $customerDesktopPrefixName `
  #  -AddressPrefix $customerDesktopPrefix `
  #  -NextHopType "VirtualAppliance" `
  #  -NextHopIpAddress $hubFirewallGatewayIp `
  #  -RouteTable $routeTable

 
#   Add-AzRouteConfig -Name $customerInfrastructurePrefixName `
   # -AddressPrefix $customerInfrastructurePrefix `
   # -NextHopType "VirtualAppliance" `
   # -NextHopIpAddress $hubFirewallGatewayIp `
   # -RouteTable $routeTable
 #Set-AzRouteTable -RouteTable $routeTable

## Add Entries to  Hub IP Groups
#$ipGroup = Get-AzIpGroup -ResourceGroupName $hubResourceGroupName -Name $hubdeskIpgName
#$ipGroup.IpAddresses.Add($customerDesktopPrefix)
#Set-AzIpGroup -IpGroup $ipGroup


#$ipGroup = Get-AzIpGroup -ResourceGroupName $hubResourceGroupName -Name $hubInfraIpgName
#$ipGroup.IpAddresses.Add($customerInfrastructurePrefix)
#Set-AzIpGroup -IpGroup $ipGroup


## Gets current NSG ruleset and specifies Scope
#$hubNsgName = Get-AzNetworkSecurityGroup -Name $hubNsgName -ResourceGroupName $hubResourceGroupName

#Add the inbound security rule.
#$hubNsgName | Add-AzNetworkSecurityRuleConfig -Name $customerRuleName001 `
 #   -Description 'Allow access between customer desktop and infrastructure networks to ADDS services using TCP' `
  #  -Access Allow `
   # -Protocol TCP `
    #-Direction Inbound `
    #-Priority $customerRuleId001 `
    #-SourceAddressPrefix $sourceIpAddress `
    #-SourcePortRange * `
    #-DestinationAddressPrefix $addsIpAddress `
    #-DestinationPortRange $addsTcpPorts

#$hubNsgName | Add-AzNetworkSecurityRuleConfig -Name $customerRuleName002 `
 #   -Description 'Allow access between customer desktop and infrastructure networks to ADDS services using UDP' `
 #   -Access Allow `
 #   -Protocol UDP `
 #   -Direction Inbound `
 #   -Priority $customerRuleId002 `
 #   -SourceAddressPrefix $sourceIpAddress `
#  -SourcePortRange * `
#    -DestinationAddressPrefix $addsIpAddress `
 #   -DestinationPortRange $addsUdpPorts

#$hubNsgName | Add-AzNetworkSecurityRuleConfig -Name $customerRuleName003 `
 #   -Description 'Allow access between customer desktop and infrastructure networks to Internal KMS using TCP' `
  #  -Access Allow `
  #  -Protocol TCP `
  #  -Direction Inbound `
   # -Priority $customerRuleId003 `
   # -SourceAddressPrefix $sourceIpAddress `
   # -SourcePortRange * `
   # -DestinationAddressPrefix '172.18.1.4' `
   # -DestinationPortRange '1688'


# Update the NSG.
#$hubNsgName | Set-AzNetworkSecurityGroup

 
