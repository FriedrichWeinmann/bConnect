<#
	.Synopsis
		Create a new StaticGroup.
	
	.DESCRIPTION
		A detailed description of the New-bConnectStaticGroup function.
	
	.Parameter Name
		Name of the StaticGroup.
	
	.Parameter ParentGuid
		Valid GUID of the parent OrgUnit in hierarchy (default: "Static Groups").
	
	.Parameter Endpoints
		Array of Endpoints.
	
	.Parameter Comment
		Comment for the StaticGroup.
	
	.Outputs
		StaticGroup (see bConnect documentation for more details).
	
	.NOTES
		Additional information about the function.
#>
function New-bConnectStaticGroup {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]$Name,
		[string]$ParentGuid = "5020494B-04D3-4654-A256-80731E953746",
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias('EndpointGuid')]
		[string[]]$Endpoints,
		[string]$Comment
	)
	
	begin {
		$Test = Test-bConnect
		
		if ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			throw $ErrorObject
		}
		$_body = @{
			Name	 = $Name;
			ParentId = $ParentGuid;
		}
		If (![string]::IsNullOrEmpty($Comment)) {
			$_body += @{ Comment = $Comment }
		}
		$_Endpoints = @()
	}
	
	process {
		
		If (![string]::IsNullOrEmpty($Endpoints)) {
			$_Endpoints += $Endpoints
		}
		
		
	}
	
	end {
		$_body += @{ EndPointIds = $_Endpoints }
		return Invoke-bConnectPost -Controller "StaticGroups" -Data $_body
	}
}