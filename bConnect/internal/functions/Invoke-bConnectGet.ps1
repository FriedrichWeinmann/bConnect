function Invoke-bConnectGet
{
<#
	.SYNOPSIS
		HTTP-GET against bConnect
	
	.DESCRIPTION
		HTTP-GET against bConnect
	
	.PARAMETER Controller
		A description of the Controller parameter.
	
	.PARAMETER Data
		Hashtable with parameters
	
	.PARAMETER Version
		bConnect version to use
	
	.PARAMETER NoVersion
		Dont use a version in the request. Needed for "info" and "version"
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]
		$Controller,
		
		[PSCustomObject]
		$Data,
		
		[string]
		$Version,
		
		[switch]
		$NoVersion
	)
	
	if (!$script:_connectInitialized)
	{
		Write-Error "bConnect module is not initialized. Use 'Initialize-bConnect' first!"
		return $false
	}
	
	if (-not $Version)
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
	
	if ($NoVersion)
	{
		$uri = "$($script:_connectUri)/$($Controller)"
	}
	else
	{
		$uri = "$($script:_connectUri)/$($Version)/$($Controller)"
	}
	
	try
	{
		if ($Data.Count -gt 0)
		{
			$restResult = Invoke-RestMethod -Uri $uri -Body $Data -Credential $script:_connectCredentials -Method Get -ContentType "application/json" -TimeoutSec $script:_ConnectionTimeout
		}
		else
		{
			$restResult = Invoke-RestMethod -Uri $uri -Credential $script:_connectCredentials -Method Get -ContentType "application/json" -TimeoutSec $script:_ConnectionTimeout
		}
		
		if ($restResult)
		{
			return $restResult
		}
		else
		{
			return $true
		}
	}
	
	catch
	{
		try
		{
			$response = ConvertFrom-Json $_
		}
		
		catch
		{
			$response = $false
		}
		
		if ($response)
		{
			throw $response.Message
		}
		else
		{
			throw $_
		}
	}
}