Function Test-bConnect() {
    <#
        .Synopsis
            INTERNAL - Validates the bConnect API Version and Connectivity
        .Parameter MinVersion
            Minimum required Version
    #>
	
	Param (
		[string]$MinVersion = "1.0"
	)
	
	If (!$script:_connectInitialized) {
		return "bConnect module is not initialized. Use 'Initialize-bConnect' first!"
	}
	else {
		try {
			$ErrorActionPreference = 
			$_connectVersion = $(Invoke-bConnectGet -Controller "info" -noVersion).bConnectVersion
			If (-not ($_connectVersion -ge $MinVersion)) {
				Return "bConnect has not the Required Version: $MinVersion"
			}			
		}
		catch {
			Throw $_.ToString()
		}

	}
	Return $true

}
