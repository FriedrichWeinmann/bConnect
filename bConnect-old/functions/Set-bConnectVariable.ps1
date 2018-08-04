<#
	.Synopsis
		Set variable for a object.

	.DESCRIPTION
		A detailed description of the Set-bConnectVariable function.

	.Parameter ObjectGuid
		Valid GUID of an object.

	.Parameter Scope
		enum bConnectVariableScope.

	.Parameter Category
		Valid variable category.

	.Parameter Name
		Valid variable name.

	.Parameter Value
		New value.

	.PARAMETER UseDefault
		A description of the UseDefault parameter.

	.Outputs
		Bool

	.NOTES
		Additional information about the function.
#>
function Set-bConnectVariable {
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipelineByPropertyName = $true)]
		[Alias('EndpointGuid')]
		[string]$ObjectGuid,
		[Parameter(Mandatory = $true)]
		[string]$Scope,
		[Parameter(Mandatory = $true)]
		[string]$Category,
		[Parameter(Mandatory = $true)]
		[string]$Name,
		[Parameter(Mandatory = $true)]
		[string]$Value,
		[switch]$UseDefault
	)

	BEGIN {
		$Test = Test-bConnect

		If ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			Throw $ErrorObject
		}
	}
	PROCESS {
		$_variable = @{
			Category   = $Category;
			Name	   = $Name;
			UseDefault = $UseDefault.ToString();
			Value	   = $Value
		}

		$_variables = @($_variable)

		$_body = @{
			ObjectId  = $ObjectGuid;
			Scope	  = $Scope;
			Variables = $_variables
		}

		$Result = Invoke-bConnectPut -Controller "Variables" -Data $_body
		$Result
	}
}