    <#
	.Synopsis
		Gets info from bConnect.
	
	.DESCRIPTION
		A detailed description of the Get-bConnectInfo function.
	
	.NOTES
		Additional information about the function.
#>
function Get-bConnectInfo {
	[CmdletBinding()]
	param ()
	
	If (!$script:_bConnectInfo) {
        $script:_bConnectInfo = Invoke-bConnectGet -Controller "info" -noVersion
	}
	
	return $script:_bConnectInfo
}