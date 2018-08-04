<#
	.Synopsis
		Get specified job or all jobs in given OrgUnit.
	.DESCRIPTION
		A detailed description of the Get-bConnectJob function.
	.Parameter JobGuid
		Valid GUID of a job.
	.Parameter OrgUnitGuid
		Valid GUID of a Orgunit.
	.PARAMETER OnlyWindowsJobs
		Lists only Jobs for Windows Endpoints
	.PARAMETER OnlyMobileJobs
		Lists only Jobs for Mobile Devices
	.PARAMETER IncludeSteps
		Includes the Job Steps in the bConnect.Job Object
	.EXAMPLE
		PS C:\> Get-bConnectJob
	.Outputs
		Array of Job (see bConnect documentation for more details).
	.NOTES
		Additional information about the function.
#>
function Get-bConnectJob {
	[CmdletBinding()]
	param
	(
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$JobGuid,
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$OrgUnitGuid,
		[switch]$OnlyWindowsJobs,
		[switch]$OnlyMobileJobs,
		[switch]$OnlyMacJobs,
		[switch]$IncludeSteps
	)
	begin {
		$Test = Test-bConnect
		if ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			throw $ErrorObject
		}
		$WhereArray = @()
		if ($OnlyWindowsJobs) {
			$WhereArray += '$_.CanRunOnMobileDevice -eq $false'
		}
		if ($OnlyMobileJobs) {
			$WhereArray += '$_.CanRunOnMobileDevice -eq $true'
		}
		if ($OnlyMacJobs) {
			$WhereArray += '$_.CanRunOnMac -eq $true'
		}
		$WhereString = $WhereArray -Join " -and "
	}
	process {
		if ($JobGuid) {
			$_body = @{
				Id = $JobGuid
			}
		}
		if ($OrgUnitGuid) {
			$_body = @{
				OrgUnit = $OrgUnitGuid
			}
		}
		
		if ($IncludeSteps) {
			$_body += @{
				Steps = $true
			}
		}
		$Result = Invoke-bConnectGet -Controller "Jobs" -Data $_body
		if (-not ([String]::IsNullOrEmpty($WhereString))) {
			Write-Verbose -Message $WhereString
			$WhereBlock = [scriptblock]::Create($WhereString)
			$Result = $Result | Where-Object -FilterScript $WhereBlock
		}
		$Result | Select-Object -Property @{ Name = "JobGuid"; Expression = { $_.ID } }, * | ForEach-Object {
			if ($_.PSObject.Properties.Name -contains 'Type') {
				Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.Job'
			}
			else {
				$_
			}
		}
	}
}