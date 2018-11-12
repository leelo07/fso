###########################################################################
#
# NAME: New-RDCManFile.ps1
#
# AUTHOR: Jan Egil Ring
# EMAIL: jer@powershell.no
#
# COMMENT: Script to create a XML-file for use with Microsoft Remote Desktop Connection Manager
#          For more details, see the following blog-post: http://blog.powershell.no/2010/06/02/dynamic-remote-desktop-connection-manager-connection-list
#
# You have a royalty-free right to use, modify, reproduce, and
# distribute this script file in any way you find useful, provided that
# you agree that the creator, owner above has no warranty, obligations,
# or liability for such use.
#
# VERSION HISTORY:
# 1.0 02.06.2010 - Initial release
#
###########################################################################

#Importing Microsoft`s PowerShell-module for administering ActiveDirectory
#Import-Module ActiveDirectory

#Initial variables
$domain = $env:userdomain
$OutputFile = "$home\$domain.rdg"

#Create a template XML
$template = @'
<?xml version="1.0" encoding="utf-8"?>
<RDCMan schemaVersion="1">
    <version>2.2</version>
    <file>
        <properties>
            <name></name>
            <expanded>True</expanded>
            <comment />
            <logonCredentials inherit="FromParent" />
            <connectionSettings inherit="FromParent" />
            <gatewaySettings inherit="FromParent" />
            <remoteDesktop inherit="FromParent" />
            <localResources inherit="FromParent" />
            <securitySettings inherit="FromParent" />
            <displaySettings inherit="FromParent" />
        </properties>
        <group>
            <properties>
                <name></name>
                <expanded>True</expanded>
                <comment />
                <logonCredentials inherit="None">
                    <userName></userName>
                    <domain></domain>
                    <password storeAsClearText="False"></password>
                </logonCredentials>
                <connectionSettings inherit="FromParent" />
                <gatewaySettings inherit="None">
                    <userName></userName>
                    <domain></domain>
                    <password storeAsClearText="False" />
                    <enabled>False</enabled>
                    <hostName />
                    <logonMethod>4</logonMethod>
                    <localBypass>False</localBypass>
                    <credSharing>False</credSharing>
                </gatewaySettings>
                <remoteDesktop inherit="FromParent" />
                <localResources inherit="FromParent" />
                <securitySettings inherit="FromParent" />
                <displaySettings inherit="FromParent" />
            </properties>
            <server>
                <name></name>
                <displayName></displayName>
                <comment />
                <logonCredentials inherit="FromParent" />
                <connectionSettings inherit="FromParent" />
                <gatewaySettings inherit="FromParent" />
                <remoteDesktop inherit="FromParent" />
                <localResources inherit="FromParent" />
                <securitySettings inherit="FromParent" />
                <displaySettings inherit="FromParent" />
            </server>
        </group>
    </file>
</RDCMan>
'@

#Output template to xml-file
$template | Out-File $home\RDCMan-template.xml -encoding UTF8

#Load template into XML object
$xml = New-Object xml
$xml.Load("$home\RDCMan-template.xml")

#Set file properties
$file = (@($xml.RDCMan.file.properties)[0]).Clone()
$file.name = $domain
$xml.RDCMan.file.properties | Where-Object { $_.Name -eq "" } | ForEach-Object  { [void]$xml.RDCMan.file.ReplaceChild($file,$_) }

#Set group properties
$group = (@($xml.RDCMan.file.group.properties)[0]).Clone()
$group.name = $env:userdomain
$group.logonCredentials.Username = $env:username
$group.logonCredentials.Domain = $domain
$xml.RDCMan.file.group.properties | Where-Object { $_.Name -eq "" } | ForEach-Object  { [void]$xml.RDCMan.file.group.ReplaceChild($group,$_) }

#Use template to add servers from Active Directory to xml 
$server = (@($xml.RDCMan.file.group.server)[0]).Clone()
Get-ADComputer -LDAPFilter "(operatingsystem=*server*)" | select name,dnshostname |
ForEach-Object {
$server = $server.clone()	
$server.DisplayName = $_.Name	
$server.Name = $_.DNSHostName
$xml.RDCMan.file.group.AppendChild($server) > $null}
#Remove template server
$xml.RDCMan.file.group.server | Where-Object { $_.Name -eq "" } | ForEach-Object  { [void]$xml.RDCMan.file.group.RemoveChild($_) }

#Save xml to file
$xml.Save($OutputFile)

#Remove template xml-file
Remove-Item $home\RDCMan-template.xml -Force