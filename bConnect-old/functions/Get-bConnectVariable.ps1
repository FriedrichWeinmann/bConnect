<#
	.Synopsis
		Get variables from a object.
	
	.DESCRIPTION
		A detailed description of the Get-bConnectVariable function.
	
	.Parameter Scope
		enum bConnectVariableScope.
	
	.Parameter Category
		Valid variable category.
	
	.Parameter Name
		Valid variable name.
	
	.Parameter ObjectGuid
		Valid GUID of an object.
	
	.PARAMETER bConnectObject
		A description of the bConnectObject parameter.
	
	.Outputs
		ObjectVariables (see bConnect documentation for more details).
	
	.NOTES
		Additional information about the function.
#>
function Get-bConnectVariable {
	[CmdletBinding(DefaultParameterSetName = 'SingleObject',
				   ConfirmImpact = 'None')]
	param
	(
		[Parameter(ParameterSetName = 'SingleObject',
				   Mandatory = $true)]
		[Parameter(ParameterSetName = 'MultipleObjects',
				   Mandatory = $false)]
		[bConnectVariableScope]$Scope,
		[string]$Category,
		[string]$Name,
		[Parameter(ParameterSetName = 'SingleObject',
				   Mandatory = $true,
				   ValueFromPipelineByPropertyName = $false)]
		[Parameter(ParameterSetName = 'MultipleObjects',
				   Mandatory = $false,
				   ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[Alias('ID')]
		[string]$ObjectGuid,
		[Parameter(ParameterSetName = 'MultipleObjects',
				   ValueFromPipeline = $true)]
		[PSCustomObject]$bConnectObject
	)
	
	BEGIN {
		$Test = Test-bConnect
		
		If ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			Throw $ErrorObject
		}
	}
	
	PROCESS {
		If ($bConnectObject.PSobject.Properties.name -contains "EndpointGuid" -and
			$bConnectObject.Type -eq [bConnectEndpointType]::WindowsEndpoint) {
			$_body = @{ Scope = [bConnectVariableScope]::Device }
		}
		elseif ($bConnectObject.PSobject.Properties.name -contains "EndpointGuid" -and
			$bConnectObject.Type -ne [bConnectEndpointType]::WindowsEndpoint -and
			$bConnectObject.Type -ne [bConnectEndpointType]::NetworkEndpoint) {
			$_body = @{ Scope = [bConnectVariableScope]::MobileDevice }
		}
		elseif ($bConnectObject.PSobject.Properties.name -contains "OrgUnitGuid") {
			$_body = @{ Scope = [bConnectVariableScope]::OrgUnit }
		}
		elseif ($bConnectObject.PSobject.Properties.name -contains "JobGuid") {
			$_body = @{ Scope = [bConnectVariableScope]::Job }
		}
		elseif ($bConnectObject.PSobject.Properties.name -contains "ApplicationGuid") {
			$_body = @{ Scope = [bConnectVariableScope]::Software }
		}
		elseif ($bConnectObject.PSobject.Properties.name -contains "HardwareProfileGuid") {
			$_body = @{ Scope = [bConnectVariableScope]::HardwareProfile }
		}
		else {
			$_body = @{ Scope = $Scope }
		}
		
		If ($Category) {
			$_body += @{ Category = $Category }
		}
		
		If ($Name) {
			$_body += @{ Name = $Name }
		}
		
		If ($ObjectGuid) {
			$_body += @{ ObjectId = $ObjectGuid }
		}
		
		$Result = Invoke-bConnectGet -Controller "Variables" -Data $_body
		$Result
	}
}