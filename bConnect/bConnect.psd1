@{
    # Script module or binary module file associated with this manifest
    ModuleToProcess    = 'bConnect.psm1'

    # Version number of this module.
    ModuleVersion      = '1.0.2.0'

    # ID used to uniquely identify this module
    GUID               = '49d01419-b666-4b78-ac69-a0a2c4512afb'

    # Author of this module
    Author             = 'Baramundi AG'

    # Company or vendor of this module
    CompanyName        = 'Baramundi AG'

    # Copyright statement for this module
    Copyright          = 'Copyright (c) 2018 Baramundi AG'

    # Description of the functionality provided by this module
    Description        = 'PowerShell Module to interact with the Baramundi bConnect Rest API'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion  = '3.0'

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of the .NET Framework required by this module
    # DotNetFrameworkVersion = '2.0'

    # Minimum version of the common language runtime (CLR) required by this module
    # CLRVersion = '2.0.50727'

    # Processor architecture (None, X86, Amd64, IA64) required by this module
    # ProcessorArchitecture = 'None'

    # Modules that must be imported into the global environment prior to importing
    # this module
    RequiredModules    = @(
        @{ ModuleName = 'PSFramework'; ModuleVersion = '0.9.24.85' }
    )

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies = @('bin\bConnect.dll')

    # Script files (.ps1) that are run in the caller's environment prior to
    # importing this module
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @('xml\bConnect.Types.ps1xml')

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess   = @('xml\bConnect.Format.ps1xml')

    # Modules to import as nested modules of the module specified in
    # ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module
    FunctionsToExport  = @(
        'Edit-bConnectApplication',
        'Edit-bConnectDynamicGroup',
        'Edit-bConnectEndpoint',
        'Edit-bConnectOrgUnit',
        'Edit-bConnectStaticGroup',
        'Get-bConnectApp',
        'Get-bConnectAppIcon',
        'Get-bConnectApplication',
        'Get-bConnectBootEnv',
        'Get-bConnectDynamicGroup',
        'Get-bConnectEndpoint',
        'Get-bConnectEndpointInvSoftware',
        'Get-bConnectEndpointOption',
        'Get-bConnectHardwareProfile',
        'Get-bConnectImages',
        'Get-bConnectInfo',
        'Get-bConnectInventoryAppScan',
        'Get-bConnectInventoryDataCustomScan',
        'Get-bConnectInventoryDataFileScan',
        'Get-bConnectInventoryDataHardwareScan',
        'Get-bConnectInventoryDataRegistryScan',
        'Get-bConnectInventoryDataSnmpScan',
        'Get-bConnectInventoryDataWmiScan',
        'Get-bConnectInventoryOverview',
        'Get-bConnectJob',
        'Get-bConnectJobInstance',
        'Get-bConnectOrgUnit',
        'Get-bConnectSoftwareScanRule',
        'Get-bConnectSoftwareScanRuleCount',
        'Get-bConnectStaticGroup',
        'Get-bConnectVariable',
        'Get-bConnectVersion',
        'Initialize-bConnect',
        'New-bConnectApplication',
        'New-bConnectApplicationAUTFileRule',
        'New-bConnectApplicationFile',
        'New-bConnectApplicationInstallationData',
        'New-bConnectApplicationInstallOptions',
        'New-bConnectApplicationInstallUserSettings',
        'New-bConnectApplicationLicense',
        'New-bConnectApplicationUninstallOptions',
        'New-bConnectApplicationUninstallUserSettings',
        'New-bConnectDynamicGroup',
        'New-bConnectEndpoint',
        'New-bConnectJobInstance',
        'New-bConnectOrgUnit',
        'New-bConnectOrgUnitExtension',
        'New-bConnectStaticGroup',
        'Remove-bConnectApplication',
        'Remove-bConnectDynamicGroup',
        'Remove-bConnectEndpoint',
        'Remove-bConnectInventoryDataFileScan',
        'Remove-bConnectInventoryDataRegistryScan',
        'Remove-bConnectJobInstance',
        'Remove-bConnectOrgUnit',
        'Remove-bConnectStaticGroup',
        'Reset-bConnect',
        'Resume-bConnectJobInstance',
        'Search-bConnectApplication',
        'Search-bConnectDynamicGroup',
        'Search-bConnectEndpoint',
        'Search-bConnectGroup',
        'Search-bConnectJob',
        'Search-bConnectOrgUnit',
        'Search-bConnectStaticGroup',
        'Set-bConnectEndpointOption',
        'Set-bConnectVariable',
        'Set-bConnectEndpoint',
        'Start-bConnectJobInstance',
        'Stop-bConnectJobInstance'
    )

    # Cmdlets to export from this module
    CmdletsToExport    = ''

    # Variables to export from this module
    VariablesToExport  = ''

    # Aliases to export from this module
    AliasesToExport    = ''

    # List of all modules packaged with this module
    ModuleList         = @()

    # List of all files packaged with this module
    FileList           = @()

    # Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData        = @{

        #Support for PowerShellGet galleries.
        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            # Tags = @()

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            # ProjectUri = ''

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''

        } # End of PSData hashtable

    } # End of PrivateData hashtable
}