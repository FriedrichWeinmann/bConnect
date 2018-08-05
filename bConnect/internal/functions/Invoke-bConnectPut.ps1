function Invoke-bConnectPut
{
<#
	.SYNOPSIS
		HTTP-PUT against bConnect
	
	.DESCRIPTION
		HTTP-PUT against bConnect
	
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
	
	try
	{
		if ($Data.Count -gt 0)
		{
			$body = ConvertTo-Json $Data
			
			$result = Invoke-RestMethod -Uri "$($script:_connectUri)/$($Version)/$($Controller)" -Body $body -Credential $script:_connectCredentials -Method Put -ContentType "application/json"
			if ($result)
			{
				return $result
			}
			else
			{
				return $true
			}
		}
		else
		{
			return $false
		}
	}
	
	catch
	{
		$errorMessage = ""
		
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
			$errorMessage = $response.Message
		}
		else
		{
			$errorMessage = $_
		}
		
		if ($body)
		{
			$errorMessage = "$($errorMessage) `nHashtable: $($body)"
		}
		
		throw $errorMessage
	}
}
