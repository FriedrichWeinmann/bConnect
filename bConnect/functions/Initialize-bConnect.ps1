Function Initialize-bConnect
{
<#
	.Synopsis
		Initialize the connection to bConnect.
	
	.DESCRIPTION
		A detailed description of the Initialize-bConnect function.
	
	.Parameter Server
		Hostname/FQDN/IP of the baramundi Management Server.
	
	.Parameter Port
		Port of bConnect (default: 443).
	
	.Parameter Credentials
		PSCredential-object with permissions in the bMS.
	
	.PARAMETER AcceptSelfSignedCertificate
		A description of the AcceptSelfSignedCertificate parameter.
	
	.Parameter AcceptSelfSignedCertificate
		Switch to ignore untrusted certificates.
	
	.EXAMPLE
		PS C:\> Initialize-bConnect -Server 'value1' -Credentials $Credentials
#>
	
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)]
		[string]
		$Server,
		
		[string]
		$Port = "443",
		
		[Parameter(Mandatory = $true)]
		[System.Management.Automation.PSCredential]
		$Credentials,
		
		[switch]
		$AcceptSelfSignedCertificate
	)
	
	If ($AcceptSelfSignedCertificate)
	{
		[System.Net.ServicePointManager]::CertificatePolicy = New-Object bConnect.Connection.CertificatePolicy
	}
	
	$uri = "https://$($Server):$($Port)/bConnect"
	
	$script:_connectInitialized = $true
	$script:_connectUri = $uri
	$script:_connectCredentials = $Credentials
	
	$Test = Test-bConnect
	
	If ($Test -ne $true)
	{
		$script:_connectInitialized = $false
		$script:_connectUri = ""
		$script:_connectCredentials = ""
		$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
		Throw $ErrorObject
	}
	else
	{
		$connectInfo = Get-bConnectInfo
		Write-PSFMessage -Level Verbose -Message "Connection with $Server established."
		Write-PSFMessage -Level Verbose -Message "bConnect version: $($connectInfo.bConnectVersion)"
		Write-PSFMessage -Level Verbose -Message "BMS version: $($connectInfo.bMSVersion)"
	}
}