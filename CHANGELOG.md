# Changelog bConnect Modul

## [1.0.2.1] - 2019-04-03

- Invoke-Cmdlets angepasst damit auch Änderungen mit Umlauten sauber an die REST API
    übertragen werden.


## [1.0.2.0] - 2018-12-18

- bConnect 2018R2 Neuerungen abgebildet

- - Endpoints können jetzt nach RegisteredUser gefiltert werden

- - Jobs können nach Kiosk User gefiltert werden

- - JobInstances können jetzt nach Endpoint und Kiosk User gefiltert werden.

    Es werden beide Parameter benötigt. Endpoint und Kiosk User. Nur nach dem
    User kann nicht gefiltert werden.

- - Get-bConnectSoftwareScanRuleCount hinzugefügt.

    Ich hab ehrlich gesagt keine Ahnung wieso das ganze nur mit bLicense funktioniert.
    So wie ich das der API Dokumentation entnehmen kann sind das alles Werte die ich
    auch über die bConnect API zusemmen stellen kann. Aus diesem Grund habe ich die
    Funktion so nachgebaut, so dass sie auch ohne bLicense geht. Allerdings nur wenn
    der Original API Aufruf fehlschlägt. Man erhält dann eine Liste mit der Zuordnung
    von Software zu PC. Mein Workaround dürfte je nach Größe der Umgebung von der
    Performance natürlich deutlich schlechter sein als ggfs. ein gespeicherter View
    auf dem SQL Server den die API ausgibt.

    Da wir aktuell kein bLicense haben kann ich nicht garantieren das der Output
    des Workaround mit dem Output der API 100%ig übereinstimmt.

- - Get-bConnectImaage hinzugeügt

    Aufruf geht nur wenn eine IconID mitgegeben wird. Diese kann man sofern ein Bild
    beim Job hinterlegt ist dem Job Objekt entnehmen.
    z.B.  Get-bconnectJob | Where {$_.Name -like "Job mit Bild"} | Get-bConnectImages -ExportPath "C:\"

    Zusätzlich ist es möglich per ExportPath einen Pfad anzugeben wo die Bilder
    abgespeichert werden. Als Name wird die ID verwendet.

- Connect String zu Get-bConnectInfo hinzugefügt damit man feststellen kann   mit welchem Server das Modul aktuell verbunden ist.

## [1.0.1.0] - 2018-11-12

- Set-bConnectEndpoint Cmdlet hinzugefügt

  Erlaubt es Werte eines Endpoints direkt zu ändern ohne den Weg über ein Endpoint Objekt zu gehen

- Erste Pester Test hinzugefügt um den Code besser zu testen

## [1.0.0.0] - 2018-08-06

- Migration zum Github Repository

- Einige Funktionen wurden durch Integration des PSFramework Moduls vereinbacht bzw. der Code lesbarer gemacht

- Ordnerstruktur wurde neu aufgebaut

- Hilfetext bei vielen Funktionen ergänzt bzw. verbessert

## [0.2.1] - 2018-08-01

### Fixed

- Set-bConnectEndpointOption
  
  Fehler beseitigt wenn anstelle einer Pipeline ein Array von EndpointGuid übergeben wird wie z.B. von Search-bConnectStaticGroup

## [0.2.0] - 2018-08-31

### Added

- Search-bConnectEndpoint

    Erlaubt nun das Suchen über den Filter Parameter. Dieser ist deutlich flexibler und liefert auch wirklich nur die Clients zurück die man möchte, bzw. nach denen man filtert. Als Filteroptionen stehen alle Eigenschaften zur Verfügung die Get-bConnectEndpoint zurück liefert.
    Nähere Infos und Erläuterungen mit Get-Help Search-bConnectEndpoint -Examples

- Search-bConnectApplication
  
  Erlaubt nun das Filtern der Ergebnisse nach Apps oder Application.

  - -*OnlySoftware* - Liefert neben den normalen Daten auch die durch BMS installierte Software mit.
  - -*OnlyApps* - Liefert neben den normalen Daten auch die SNMP Daten des Endpunkts mit.

- Pipline Support für weiter Cmdlets. Sämtliche Edit-bConnect* Cmdlets können jetzt Inhalte von den zugehörigen Get-bConnect Varianten verarbeiten.
  Der Ouptut von Search-bConnectEndpoint kann jetzt einfach genutzt werden um eine neue statische Gruppe zu erzeugen.

  z.B. Search-bConnectEndpoint -Filter '$_.OperatingSystem -like "Windows Server*"' | New-bConnectStaticGroup -Name "Windows Server Clients"

- Parameter Validierung. Bei allen Cmdlets erfolgt nun bereits am Parameter eine Regex Prüfung ob ein gültiger ID Wert übergeben wurde.

- -WhatIf/ -Confirm Support für folgende Cmdlets:
  - Edit-bConnectApplication
  - Edit-bConnectDynamicGroup
  - Edit-bConnectEndpoint
  - Edit-bConnectOrgUnit
  - Edit-bConnectStaticGroup
  - Remove-bConnectApplication
  - Remove-bConnectApplicationMswFiles
  - Remove-bConnectDynamicGroup
  - Remove-bConnectEndpoint
  - Remove-bConnectInventoryDataFileScan
  - Remove-bConnectInventoryDataRegistryScan
  - Remove-bConnectJobInstance
  - Remove-bConnectOrgUnit
  - Remove-bConnectStaticGroup
  - Set-bConnectEndpointOption

### Changed

- Änderung des Connection Check innerhalb der einzelnen Cmdlets
- Get-bConnectVersion Liefert jetzt jeweils ein [System.Version] Object zurück. Davor war eine Filterung nach z.B. nach BMS Version größer 16 nur schwer möglich. Bestehende Abfragen sollten jedoch trotzdem weiter laufen da das Objekt Standardmäßig die Version als String zurückliefert.
  Man kann jetzt aber unkompliziert über $(Get-bConnectVersion -bMSVersion).Major oder $(Get-bConnectVersion -bMSVersion).Minor die jeweilige Release Version mit den Operatoren "-eq", "-gt", usw. prüfen.

## [0.1.0] - 2018-07-09

### Added

- Get-bConnectEndpointOption

    Erlaubt die Abfrage nach den Endpunkt Optionen z.B. Allow OS Installation, Auto Installation, User Update Einstellungen, User Job Einstellung, Energiemanagent und Anwendungsüberwachung.

- Set-bConnectEndpointOption

     Erlaubt das setzen der Endpunkt Optionen z.B. Allow OS Installation, Auto Installation, User Update Einstellungen, User Job Einstellung, Energiemanagent und Anwendungsüberwachung.

- Get-bConnectEndpoint
  - -*IncludeSoftware* - Liefert neben den normalen Daten auch die durch BMS installierte Software mit.
  - -*IncludeSnmpData* - Liefert neben den normalen Daten auch die SNMP Daten des Endpunkts mit.
- Search-bConnectEndpoint
  - -*Type* - Einschränkung nach der Art des Endpunkts (Windows, Mobile Device usw.)
  - -*OnlyActiveClients* - Zeigt nur die Aktiven Clients an.

- Pipline Support für Get-bConnectEndpoint, Get-bConnectJob

### Changed

- Initialize-bConnect - Es wird nun direkt geprüft ob eine Verbindung möglich ist. Bisher wurde nur der API String konfiguriert. Eine Verbindung ist erst beim Aufruf des ersten Commands passiert.

### Fixed

- New-bConnectStaticGroup - Gruppe wurde zwar angelegt. Es konnten der Gruppe jedoch keine Endpunkte hinzugefügt werden.