Function Get-bConnectVersion
{
<#
	.SYNOPSIS
		Checks for supported bConnect version and returns the version.
	
	.DESCRIPTION
		Checks for supported bConnect version and returns the version.
	
	.PARAMETER bMSVersion
		Rather than the bCOnnect version, return the version of the bMS service connected to.
	
	.EXAMPLE
		PS C:\> Get-bConnectVersion
	
		Returns the version of the bConnect api connected to.
	
	.EXAMPLE
		PS C:\> Get-bConnectVersion -bMSVersion
	
		Returns the version of the bMS server connected to via the bConnect Api.
#>
	[CmdletBinding()]
	Param (
		[switch]
		$bMSVersion
	)
	
	$info = Get-bConnectInfo
	
	if ($info)
	{
		$bcVersion = [System.Version]::Parse($info.bConnectVersion)
		$bmsVersion = [System.Version]::Parse($info.bMSVersion)
		Write-PSFMessage -Level Verbose -Message "Versions detected: bConnect: $($bcVersion) | BMS: $($bMSVersion)"
		switch -Wildcard ($bmsVersion)
		{
			"14.0.*" {
				Write-PSFMessage -Level Warning -Message "DEPRECATED! bConnect 2014R1 detected" -Once "bConnect_$($script:_connectUri)"
			}
			
			"14.2.*" {
				Write-PSFMessage -Level Warning -Message "DEPRECATED! bConnect 2014R2 detected" -Once "bConnect_$($script:_connectUri)"
			}
			
			"15.*" {
				Write-PSFMessage -Level Verbose -Message "DEPRECATED! bConnect 2015R1 or (somewhat) newer detected" -Once "bConnect_$($script:_connectUri)"
			}
			
			"16.*" {
				Write-PSFMessage -Level Verbose -Message "DEPRECATED! bConnect 2016R1 or (somewhat) newer detected" -Once "bConnect_$($script:_connectUri)"
			}
			
			"17.*" {
				#Write-Verbose "bConnect 2017R1 or newer"
			}
			
			"18.*" {
				#Write-Verbose "bConnect 2018R1 or newer"
			}
			
			default
			{
				Write-PSFMessage -Level Warning -Message "NOT SUPPORTED! Unknown bConnect Version -> Fallback to $($script:_bConnectFallbackVersion)" -Once "bConnect_$($script:_connectUri)"
				$bcVersion = $script:_bConnectFallbackVersion
			}
		}
		
		if ($bMSVersion)
		{
			$bmsVersion
		}
		else
		{
			$bcVersion
		}
	}
}