﻿<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2020 v5.7.172
	 Created on:   	3/19/2020 11:51
	 Created by:   	Claussen
	 Organization: 	NEOnet
	 Filename:     	New-NetboxIPAMAddress.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>


function New-NetboxIPAMAddress {
<#
    .SYNOPSIS
        Create a new IP address to Netbox
    
    .DESCRIPTION
        Create a new IP address to Netbox with a status of Active by default.
    
    .PARAMETER Address
        IP address in CIDR notation: 192.168.1.1/24
    
    .PARAMETER Status
        Status of the IP. Defaults to Active
    
    .PARAMETER Tenant
        Tenant ID
    
    .PARAMETER VRF
        VRF ID
    
    .PARAMETER Role
        Role such as anycast, loopback, etc... Defaults to nothing
    
    .PARAMETER NAT_Inside
        ID of IP for NAT
    
    .PARAMETER Custom_Fields
        Custom field hash table. Will be validated by the API service
    
    .PARAMETER Interface
        ID of interface to apply IP
    
    .PARAMETER Description
        Description of IP address
    
    .PARAMETER Raw
        Return raw results from API service
    
    .EXAMPLE
        PS C:\> Create-NetboxIPAMAddress
    
    .NOTES
        Additional information about the function.
#>
    
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Address,
        
        [object]$Status = 'Active',
        
        [uint16]$Tenant,
        
        [uint16]$VRF,
        
        [object]$Role,
        
        [uint16]$NAT_Inside,
        
        [hashtable]$Custom_Fields,
        
        [uint16]$Interface,
        
        [string]$Description,
        
        [switch]$Raw
    )
    
    $PSBoundParameters.Status = ValidateIPAMChoice -ProvidedValue $Status -IPAddressStatus
    
    if ($null -ne $Role) {
        $PSBoundParameters.Role = ValidateIPAMChoice -ProvidedValue $Role -IPAddressRole
    }
    
    $segments = [System.Collections.ArrayList]::new(@('ipam', 'ip-addresses'))
    
    $URIComponents = BuildURIComponents -URISegments $segments -ParametersDictionary $PSBoundParameters
    
    $URI = BuildNewURI -Segments $URIComponents.Segments
    
    InvokeNetboxRequest -URI $URI -Method POST -Body $URIComponents.Parameters -Raw:$Raw
}