[cmdletbinding()]
param()

# fallback bConnect version
$script:_bConnectFallbackVersion = "v1.0"

# overwrite Invoke-RestMethod timout
$script:_ConnectionTimeout = 0

# CAUTION - dirty workaround
# Only to ignore certificates errors (self-signed)
Add-Type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;

public class ignoreCertificatePolicy : ICertificatePolicy {
    public ignoreCertificatePolicy() {}
    public bool CheckValidationResult(ServicePoint sPoint, X509Certificate cert, WebRequest wRequest, int certProb) { return true; }
}
"@

#--- Types ---
# enum for Endpoint types
Add-Type -TypeDefinition @"
public enum bConnectEndpointType
{
    Unknown = 0,
    WindowsEndpoint = 1,
    AndroidEndpoint = 2,
    iOSEndpoint = 3,
    MacEndpoint = 4,
    WindowsPhoneEndpoint = 5,
    NetworkEndpoint = 16
}
"@

# enum for SearchResult types
Add-Type -TypeDefinition @"
public enum bConnectSearchResultType
{
    Unknown = 0,
    WindowsEndpoint = 1,
    AndroidEndpoint = 2,
    iOSEndpoint = 3,
    MacEndpoint = 4,
    WindowsPhoneEndpoint = 5,
    WindowsJob = 6,
    BmsNetJob = 7,
	OrgUnit = 8,
	DynamicGroup = 9,
	StaticGroup = 10,
    Application = 11,
    App = 12,
    NetworkEndpoint = 16
}
"@
# enum for Variable scopes
Add-Type -TypeDefinition @"
public enum bConnectVariableScope
{
    Device,
    MobileDevice,
    OrgUnit,
    Job,
    Software,
    HardwareProfile
}
"@
# enum for Variable types
Add-Type -TypeDefinition @"
public enum bConnectVariableType
{
    Unknown,
    Number,
    String,
    Date,
    Checkbox,
    Dropdownbox,
    DropdownListbox,
    Filelink,
    Folder,
    Password,
    Certificate
}
"@

# enum for InventoryScan types
Add-Type -TypeDefinition @"
public enum bConnectInventoryScanType
{
    Unknown,
    Custom,
    WMI,
    Hardware
}
"@

Add-Type -TypeDefinition @"
public enum bConnectReleaseLevel
{
	NotConfigured = 200,
	ReleaseDenied = 300,
	ReleasedForTest = 400,
	Released = 500
}
"@

# enum for Endpoint Options 
Add-Type -TypeDefinition @"
[System.Flags]
public enum EndpointOptions {
	AllowOSInstall = 1,
	AllowAutoInstall = 2,
	UpdatePrimaryUserOnNextLogon = 4,
	AlwaysUpdatePrimaryUser = 8,
	NeverUpdatePrimaryUser = 12,
	NeverExecuteUserRelatedJobs = 16,
	ExecuteUserRelatedJobsPrimaryUser = 48,
	AutomaticUsageTracking = 256,
	EnergyManagement = 512,
}
"@


# enum for PrimaryUserUpdateOptions types
Add-Type -TypeDefinition @"
[System.Flags]
public enum bConnectEndpointPrimaryUserUpdateOption
{
    UpdateAtNextLogon = 0,
    DoNotUsePrimaryUser = 4,
    AlwaysUpdatePrimaryUser = 8,
    NeverUpdatePrimaryUser = 12
}
"@

# enum for UserJobOptions types
Add-Type -TypeDefinition @"
[System.Flags]
public enum bConnectEndpointUserJobOptions
{
    AlwaysExecuteUserJobs = 0,
    NeverExecuteUserJobs = 16,
    ExecuteUserRelatedJobsPrimaryUser = 48
}
"@

#--- Core ---
# init the connection (uri and credentials)
$script:_connectInitialized = $false

Write-Verbose $PSScriptRoot

Write-Verbose 'Import everything in sub folders folder'

foreach($folder in @('internal', 'functions'))

{

    $root = Join-Path -Path $PSScriptRoot -ChildPath $folder

    if(Test-Path -Path $root)

    {

        Write-Verbose "processing folder $root"

        $files = Get-ChildItem -Path $root -Filter *.ps1 -Recurse



        # dot source each file

        $files | where-Object{ $_.name -NotLike '*.Tests.ps1'} | 

            ForEach-Object{Write-Verbose $_.basename; . $_.FullName}

    }

}



Export-ModuleMember -function (Get-ChildItem -Path "$PSScriptRoot\functions\*.ps1").basename