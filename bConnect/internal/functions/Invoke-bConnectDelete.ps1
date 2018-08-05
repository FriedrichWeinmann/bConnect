function Invoke-bConnectDelete
{
<#
	.SYNOPSIS
		HTTP-DELETE against bConnect
	
	.DESCRIPTION
		HTTP-DELETE against bConnect
	
	.PARAMETER Controller
		A description of the Controller parameter.
	
	.PARAMETER Data
		Hashtable with parameters
	
	.PARAMETER Version
		bConnect version to use
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]
		$Controller,
		
		[Parameter(Mandatory = $true)]
		[PSCustomObject]
		$Data,
		
		[string]
		$Version
	)
	
	if (!$script:_connectInitialized)
	{
		Write-Error "bConnect module is not initialized. Use 'Initialize-bConnect' first!"
		return $false
	}
	
	if ([string]::IsNullOrEmpty($Version))
	{
		$Version = $script:_bConnectFallbackVersion
	}
	
	if ($verbose)
	{
		$ProgressPreference = "Continue"
	}
	else
	{
		$ProgressPreference = "SilentlyContinue"
	}
	
	try
	{
		$_params = @()
		foreach ($_key in $Data.Keys)
		{
			$_params += "$($_key)=$($Data.Get_Item($_key))"
		}
		
		$_rest = Invoke-RestMethod -Uri "$($script:_connectUri)/$($Version)/$($Controller)?$($_params)" -Credential $script:_connectCredentials -Method Delete -ContentType "application/json"
		if ($_rest)
		{
			return $_rest
		}
		else
		{
			return $true
		}
	}
	
	catch
	{
		$_errMsg = ""
		
		try
		{
			$_response = ConvertFrom-Json $_
		}
		
		catch
		{
			$_response = $false
		}
		
		if ($_response)
		{
			$_errMsg = $_response.Message
		}
		else
		{
			$_errMsg = $_
		}
		
		if ($_body)
		{
			$_errMsg = "$($_errMsg) `nHashtable: $($Data)"
		}
		
		Write-Error $_errMsg
		
		return $false
	}
}
