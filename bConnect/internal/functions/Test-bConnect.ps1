Function Test-bConnect
{
<#
	.SYNOPSIS
		Validates the bConnect API Version and Connectivity
	
	.DESCRIPTION
		Validates the bConnect API Version and Connectivity
	
	.PARAMETER MinVersion
		Minimum required Version
	
	.EXAMPLE
		PS C:\> Test-bConnect
	
		Returns, whether a functioning connection exists.
#>
	[CmdletBinding()]
	Param (
		[version]
		$MinVersion = "1.0"
	)
	
	If (-not $script:_connectInitialized)
	{
		Write-PSFMessage -Level Warning -Message "bConnect module is not initialized. Use 'Initialize-bConnect' first!"
		return $false
	}
	else
	{
		try
		{
			[version]$connectVersion = (Invoke-bConnectGet -Controller "info" -NoVersion).bConnectVersion
			If ($connectVersion -lt $MinVersion)
			{
				Write-PSFMessage -Level Warning -Message "bConnect has not the Required Version: $MinVersion (version detected: $connectVersion)"
				return $false
			}
			
			return $true
		}
		catch
		{
			Write-PSFMessage -Level Warning -Message "Error checking the available version" -ErrorRecord $_
			return $false
		}
	}
}
