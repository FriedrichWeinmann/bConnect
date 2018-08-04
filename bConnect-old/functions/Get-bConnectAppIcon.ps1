<#
	.Synopsis
		Get the icon for specified app or all apps within a scope.
	
	.DESCRIPTION
		A detailed description of the Get-bConnectAppIcon function.
	
	.Parameter AppGuid
		Valid GUID of a app.
	
	.Parameter Scope
		Valid scope (App/Inventory).
	
	.Outputs
		Array of Icon (see bConnect documentation for more details).
	
	.NOTES
		Additional information about the function.
#>
function Get-bConnectAppIcon {
	param
	(
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$AppGuid,
		[ValidateSet('App', 'Inventory')]
		[string]$Scope
	)
	
	BEGIN {
		$Test = Test-bConnect
		
		If ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			Throw $ErrorObject
		}
	}
	
	PROCESS {
		If ($Scope) {
			$_body = @{
				Scope    = $Scope
			}
		}
		
		If ($AppGuid) {
			$_body = @{
				AppId    = $AppGuid
			}
		}
		
		$Result = Invoke-bConnectGet -Controller "Icons" -Data $_body
		$Result = $Result | ForEach-Object {
			if ($_.PSObject.Properties.Name -contains 'AppId') {
				Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.AppIcon'
			}
			else {
				$_
			}
		}
	}
	END {
		$Result
	}
}