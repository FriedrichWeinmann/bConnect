Function Initialize-bConnect() {
    <#
        .Synopsis
            Initialize the connection to bConnect.
        .Parameter Server
            Hostname/FQDN/IP of the baramundi Management Server.
        .Parameter Port
            Port of bConnect (default: 443).
        .Parameter Credentials
            PSCredential-object with permissions in the bMS.
        .Parameter AcceptSelfSignedCertificate
            Switch to ignore untrusted certificates.
    #>
	
	Param (
		[Parameter(Mandatory = $true)]
		[string]$Server,
		[string]$Port = "443",
		[Parameter(Mandatory = $true)]
		[System.Management.Automation.PSCredential]$Credentials,
		[switch]$AcceptSelfSignedCertifcate
	)
	
	If ($AcceptSelfSignedCertifcate) {
		[System.Net.ServicePointManager]::CertificatePolicy = New-Object ignoreCertificatePolicy
	}
	
	$_uri = "https://$($Server):$($Port)/bConnect"

	$script:_connectInitialized = $true
	$script:_connectUri = $_uri
	$script:_connectCredentials = $Credentials

	$Test = Test-bConnect
		
	If ($Test -ne $true) {
		$script:_connectInitialized = $false
		$script:_connectUri = ""
		$script:_connectCredentials = ""
		$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
		Throw $ErrorObject
	}
	else {
		$_connectInfo = Get-bConnectInfo
		Write-Verbose -Message "Verbindung mit $Server hergestellt."
		Write-Verbose -Message "bConnect Version: $($_connectInfo.bConnectVersion)"
		Write-Verbose -Message "BMS Version: $($_connectInfo.bMSVersion)"
	}
}