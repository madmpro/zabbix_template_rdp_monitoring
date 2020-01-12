# Improved by madm.pro
# Originally created by Diego Cavalcante - 10/02/2017
# Monitoring Windows RDP - Terminal Server

Param(
  [string]$select
)


Import-Module PSTerminalServices

Switch ($select){


    # Active Users: Domain Name, Username, Computer Name, IP Address
    'ACTIVE'
    {
        Get-TSSession -State Active -ComputerName localhost | foreach {$_.DomainName, $_.UserName, $_.ClientName, (($_.IPAddress).IPAddressToString), ""}
    }

    # Total Active Users
    'ACTIVENUM'
    {
        Get-TSSession -State Active -ComputerName localhost | foreach {$_.UserName} | Measure-Object -Line | select-object Lines | select-object -ExpandProperty Lines
    }

    # Inactive Users: Domain Name, Username
    'INACTIVE'
    {
        Get-TSSession -State Disconnected -ComputerName localhost | where { $_.SessionID -ne 0 } | foreach {$_.DomainName, $_.UserName, ""}
    }

    # Toal Inactive Users
    'INACTIVENUM'
    {
        Get-TSSession -State Disconnected -ComputerName localhost | where { $_.SessionID -ne 0 } | foreach {$_.UserName} | Measure-Object -Line | select-object Lines | select-object -ExpandProperty Lines
    }

    # List of Remote Computer Names
    'DEVICE'
    {
        Get-TSSession -State Active -ComputerName localhost | foreach {$_.ClientName}
    }

    # List of Remoter IP Addresses
    'IP'
    {
        Get-TSSession -State Active -ComputerName localhost | foreach {(($_.IPAddress).IPAddressToString)}
    }
}
