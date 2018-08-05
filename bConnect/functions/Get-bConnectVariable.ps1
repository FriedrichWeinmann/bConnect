function Get-bConnectVariable
{
<#
	.SYNOPSIS
		Get variables from a object.
	
	.DESCRIPTION
		Get variables from a object.
	
	.PARAMETER Scope
		enum bConnectVariableScope.
	
	.PARAMETER Category
		Valid variable category.
	
	.PARAMETER Name
		Valid variable name.
	
	.PARAMETER ObjectGuid
		Valid GUID of an object.
	
	.PARAMETER bConnectObject
		An arbitrary object returned by a bConnect command.
		Specifying this will cause this command to return variables affecting that objecttype.
#>
	[CmdletBinding(DefaultParameterSetName = 'SingleObject', ConfirmImpact = 'None')]
	param
	(
		[Parameter(ParameterSetName = 'SingleObject', Mandatory = $true)]
		[Parameter(ParameterSetName = 'MultipleObjects')]
		[bConnectVariableScope]
		$Scope,
		
		[string]
		$Category,
		
		[string]
		$Name,
		
		[Parameter(ParameterSetName = 'SingleObject', Mandatory = $true, ValueFromPipelineByPropertyName = $false)]
		[Parameter(ParameterSetName = 'MultipleObjects', ValueFromPipelineByPropertyName = $true)]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[Alias('ID')]
		[string]
		$ObjectGuid,
		
		[Parameter(ParameterSetName = 'MultipleObjects', ValueFromPipeline = $true)]
		$bConnectObject
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	
	process
	{
		$body = @{ }
		if ($bConnectObject.PSobject.Properties.name -contains "EndpointGuid" -and
			$bConnectObject.Type -eq [bConnectEndpointType]::WindowsEndpoint)
		{
			$body['Scope'] = [bConnectVariableScope]::Device
		}
		elseif ($bConnectObject.PSobject.Properties.name -contains "EndpointGuid" -and
			$bConnectObject.Type -ne [bConnectEndpointType]::WindowsEndpoint -and
			$bConnectObject.Type -ne [bConnectEndpointType]::NetworkEndpoint)
		{
			$body['Scope'] = [bConnectVariableScope]::MobileDevice
		}
		elseif ($bConnectObject.PSobject.Properties.name -contains "OrgUnitGuid")
		{
			$body['Scope'] = [bConnectVariableScope]::OrgUnit
		}
		elseif ($bConnectObject.PSobject.Properties.name -contains "JobGuid")
		{
			$body['Scope'] = [bConnectVariableScope]::Job
		}
		elseif ($bConnectObject.PSobject.Properties.name -contains "ApplicationGuid")
		{
			$body['Scope'] = [bConnectVariableScope]::Software
		}
		elseif ($bConnectObject.PSobject.Properties.name -contains "HardwareProfileGuid")
		{
			$body['Scope'] = [bConnectVariableScope]::HardwareProfile
		}
		else { $body['Scope'] = $Scope }
		
		if ($Category) { $body['Category'] = $Category }
		if ($Name) { $body['Name'] = $Name }
		if ($ObjectGuid) { $body['ObjectGuid'] = $ObjectGuid }
		
		Invoke-bConnectGet -Controller "Variables" -Data $body
	}
}