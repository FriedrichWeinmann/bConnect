function Get-bConnectJob
{
    <#
	.Synopsis
		Get specified job or all jobs in given OrgUnit.

	.DESCRIPTION
		Get specified job or all jobs in given OrgUnit.

	.PARAMETER JobGuid
		Valid GUID of a job.

	.PARAMETER OrgUnitGuid
        Valid GUID of a Orgunit.

    .PARAMETER User
        Valid Registered User Name. For example: mike.miller@contoso.org
        Only User Principal Names are allowed

	.PARAMETER OnlyWindowsJobs
		Lists only Jobs for Windows Endpoints

	.PARAMETER OnlyMobileJobs
		Lists only Jobs for Mobile Devices

	.PARAMETER OnlyMacJobs
		A description of the OnlyMacJobs parameter.

	.PARAMETER IncludeSteps
		Includes the Job Steps in the bConnect.Job Object

	.OUTPUTS
		bConnect.Job
#>
    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
        [string]
        $JobGuid,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
        [string]
        $OrgUnitGuid,

        [String]
        $User,

        [switch]
        $OnlyWindowsJobs,

        [switch]
        $OnlyMobileJobs,

        [switch]
        $OnlyMacJobs,

        [switch]
        $IncludeSteps
    )
    begin
    {
        Assert-bConnectConnection

        #region Filter condition
        $onlyWindowsBound = Test-PSFParameterBinding -ParameterName OnlyWindowsJobs
        $onlyMobileBound = Test-PSFParameterBinding -ParameterName OnlyMobileJobs
        $onlyMacBound = Test-PSFParameterBinding -ParameterName OnlyMacJobs

        $jobFilter = {
            if (($onlyWindowsBound) -and ($_.CanRunOnWindows -ne $OnlyWindowsJobs))
            {
                return $false
            }
            if (($onlyMobileBound) -and ($_.CanRunOnMobileDevice -ne $OnlyMobileJobs))
            {
                return $false
            }
            if (($onlyMacBound) -and ($_.CanRunOnMac -ne $OnlyMacJobs))
            {
                return $false
            }
            $true
        }
        #endregion Filter condition
    }
    process
    {
        $body = @{ }
        if ($JobGuid) { $body['Id'] = $JobGuid }
        if ($OrgUnitGuid) { $body['OrgUnit'] = $OrgUnitGuid }
        if ($IncludeSteps) { $body['Steps'] = $true }
        if ($User) { $body["User"] = $User }

        Invoke-bConnectGet -Controller "Jobs" -Data $body |
            Where-Object $jobFilter |
            Select-PSFObject "ID as JobGuid", * |
            Add-ObjectDetail -TypeName 'bConnect.Job' -WithID
    }
}