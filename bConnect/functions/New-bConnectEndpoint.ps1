function New-bConnectEndpoint
{
<#
	.SYNOPSIS
		Create a new endpoint.
	
	.DESCRIPTION
		Create a new endpoint.
	
	.PARAMETER Type
		enum bConnectEndpointType.
	
	.PARAMETER DisplayName
		DisplayName of the new endpoint. This is also used as hostname for Windows-Endpoints.
	
	.PARAMETER GroupGuid
		Valid GUID of the target OU (default: "Logical Group").
	
	.PARAMETER PrimaryUser
		Primary user of this endpoint. Mandatory for WindowsPhone-Endpoints.
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[bConnectEndpointType]
		$Type,
		
		[Parameter(Mandatory = $true)]
		[string]
		$DisplayName,
		
		[string]
		$GroupGuid = "C1A25EC3-4207-4538-B372-8D250C5D7908",
		
		[string]
		$PrimaryMac,
		
		[string]
		$HostName,
		
		[string]
		$Domain,
		
		[string]
		$Options,
		
		[string]
		$GuidBootEnvironment,
		
		[string]
		$GuidHardwareProfile,
		
		[string]
		$PrimaryUser = ""
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		$body = @{
			Type	    = $type;
			DisplayName = $displayname;
			GuidGroup   = $groupGuid;
			PrimaryUser = $primaryUser
		}
		
		if ($Type -eq [bConnectEndpointType]::WindowsEndpoint)
		{
			if ($PrimaryMac) { $body['PrimaryMac'] = $PrimaryMac }
			if ($HostName) { $body['HostName'] = $HostName }
			if ($Domain) { $body['Domain'] = $Domain }
			if ($Options) { $body['Options'] = $Options }
			if ($GuidBootEnvironment) { $body['GuidBootEnvironment'] = $GuidBootEnvironment }
			if ($GuidHardwareProfile) { $body['GuidHardwareProfile'] = $GuidHardwareProfile }
		}
		
		Invoke-bConnectPost -Controller "Endpoints" -Data $body
	}
}