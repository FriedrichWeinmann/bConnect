# bConnect

## Version 0.2.1

Authored by Tobias Mueller

Das Modul basiert auf der bConnect Version von Alexander Haugk vom 08.09.2017.

Folgende Befehle stehen zur Zeit zur Verfügung:

### Installation

Zur Installation kann man eine Powershell Console mit Administrator Rechten starten und anschließend das Script "inst_bconnect-module.ps1" ausführen.

Alternativ kann man das ganze auch manuell in folgende Pfade installieren:
Powershell x86: %Systemroot%\system32\WindowsPowerShell\v1.0\Modules\bConnect
Powershell x64: %Systemroot%\syswow64\WindowsPowerShell\v1.0\Modules\bConnect
Powershell User Modules: %Userprofile%\Documents\WindowsPowerShell\Modules

Wenn bConnect im User Module Ordner liegt ist es natürlich nur für den entsprechenden Benutzer verfügbar.

### Nutzung

Um das Modul zu nutzen kann man folgendes Snippet nutzen:

```
Import-Module -Name bConnect
```

Mit gültigem Zertifikat:

```
Initialize-bconnect -Server "<ServerName>" -Credentials "<Username>"
```

Mit selbstsigniertem Zertifikat:

```
Initialize-bconnect -Server "<ServerName>" -Credentials "<Username>" -AcceptSelfSignedCertifcate
```

Für ein Script ohne Benutzereingriff muss vorher ein Credentials Object erzeugt werden und als -Credential Parameter übergeben werden. Dann klappt es auch unattended.

## Verfügbare Cmdlets

### Core

- Initialize-bConnect
- Reset-bConnect
- Get-bConnectInfo

### Search

- Search-bConnectEndpoint
- Search-bConnectOrgUnit
- Search-bConnectGroup
- Search-bConnectStaticGroup
- Search-bConnectDynamicGroup
- Search-bConnectJob
- Search-bConnectApplication

### Org Unit

- New-bConnectOrgUnitExtension
- Get-bConnectOrgUnit
- New-bConnectOrgUnit
- Remove-bConnectOrgUnit
- Edit-bConnectOrgUnit

### Dynamic Group

- Get-bConnectDynamicGroup
- New-bConnectDynamicGroup
- Remove-bConnectDynamicGroup
- Edit-bConnectDynamicGroup

### Static Group

- Get-bConnectStaticGroup
- New-bConnectStaticGroup
- Remove-bConnectStaticGroup
- Edit-bConnectStaticGroup

### Endpoint

- Get-bConnectEndpoint
- New-bConnectEndpoint
- Remove-bConnectEndpoint
- Edit-bConnectEndpoint
- Get-bConnectEndpointOption
- Set-bConnectEndpointOption

### Hardware Profile

- Get-bConnectHardwareProfile

### Boot Environments

- Get-bConnectBootEnv

### Application

- Get-bConnectApplication
- New-bConnectApplication
- New-bConnectApplicationInstallOptions
- New-bConnectApplicationInstallUserSettings
- New-bConnectApplicationInstallationData
- New-bConnectApplicationUninstallOptions
- New-bConnectApplicationUninstallUserSettings
- New-bConnectApplicationUninstallationData
- New-bConnectApplicationAUTFileRule
- New-bConnectApplicationLicense
- Remove-bConnectApplication
- Edit-bConnectApplication

### App

- Get-bConnectApp
- Get-bConnectAppIcon

### Job

- Get-bConnectJob

### Job Instance

- Get-bConnectJobInstance
- New-bConnectJobInstance
- Start-bConnectJobInstance
- Stop-bConnectJobInstance
- Resume-bConnectJobInstance
- Remove-bConnectJobInstance

### Variables

- Get-bConnectVariable
- Set-bConnectVariable

### Inventory

- Get-bConnectInventoryDataRegistryScan
- Remove-bConnectInventoryDataRegistryScan
- Get-bConnectInventoryDataFileScan
- Remove-bConnectInventoryDataFileScan
- Get-bConnectInventoryDataWmiScan
- Get-bConnectInventoryDataCustomScan
- Get-bConnectInventoryDataHardwareScan
- Get-bConnectInventoryDataSnmpScan
- Get-bConnectInventoryOverview
- Get-bConnectSoftwareScanRule
- Get-bConnectEndpointInvSoftware
- Get-bConnectInventoryAppScan