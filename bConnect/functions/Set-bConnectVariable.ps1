function Set-bConnectVariable
{
<#
	.SYNOPSIS
		Set variable for a object.

	.DESCRIPTION
		Set variable for a object.

	.PARAMETER ObjectGuid
		Valid GUID of an object.

	.PARAMETER Scope
		enum bConnectVariableScope.

	.PARAMETER Category
		Valid variable category.

	.PARAMETER Name
		Valid variable name.

	.PARAMETER Value
		New value.
#>	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[Alias('EndpointGuid')]
		[string]
		$ObjectGuid,
		
		[Parameter(Mandatory = $true)]
		[bConnectVariableScope]
		$Scope,
		
		[Parameter(Mandatory = $true)]
		[string]
		$Category,
		
		[Parameter(Mandatory = $true)]
		[string]
		$Name,
		
		[Parameter(Mandatory = $true)]
		[string]
		$Value,
		
		[switch]
		$UseDefault
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		$variable = @{
			Category   = $Category
			Name	   = $Name
			UseDefault = $UseDefault.ToString()
			Value	   = $Value
		}
		
		$variables = @($variable)
		
		$body = @{
			ObjectId  = $ObjectGuid
			Scope	  = $Scope
			Variables = $variables
		}
		
		Invoke-bConnectPut -Controller "Variables" -Data $body
	}
}