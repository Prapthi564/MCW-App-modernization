param (
    [Parameter(Mandatory = $true)]
    [string]
    $AzureUserName,
 
    [string]
    $AzurePassword,
 
    [string]
    $AzureTenantID,
 
    [string]
    $AzureSubscriptionID,
 
    [string]
    $ODLID,
 
    [string]
    $DeploymentID,
 
    [string]
    $vmAdminUsername,
 
    [string]
    $adminPassword,
 
    [string]
    $trainerUserName,
 
    [string]
    $trainerUserPassword
)

Start-Transcript -Path C:\WindowsAzure\Logs\CloudLabsCustomScriptExtension.txt -Append

$vmAdminUsername="demouser"
$trainerUserName="trainer"
$trainerUserPassword="$adminPassword"


[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
 
#Import Common Functions
$path = pwd
$path=$path.Path
$commonscriptpath = "$path" + "\cloudlabs-common\cloudlabs-windows-functions.ps1"
. $commonscriptpath
#Installing Modern VM Validator
InstallModernVmValidator
 
CreateCredFile $AzureUserName $AzurePassword $AzureTenantID $AzureSubscriptionID $DeploymentID

Enable-CloudLabsEmbeddedShadow $vmAdminUsername $trainerUserName $trainerUserPassword

az provider register --namespace "Microsoft.LoadTestService"

#Reset VM password to update it to random password, it is a custom image based VM
net user $adminUsername $adminPassword

# Dowload logon task file
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://github.com/CloudLabs-MCW/MCW-App-modernization/blob/Migrate-Secure/Hands-on%20lab/lab-files/ARM-template/logontask.ps1", "C:\LabFiles\logontask.ps1")

$LabFilesDirectory = "C:\LabFiles"

#Enable Autologon
$AutoLogonRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty -Path $AutoLogonRegPath -Name "AutoAdminLogon" -Value "1" -type String
Set-ItemProperty -Path $AutoLogonRegPath -Name "DefaultUsername" -Value "$($env:ComputerName)\demouser" -type String
Set-ItemProperty -Path $AutoLogonRegPath -Name "DefaultPassword" -Value $adminPassword -type String
Set-ItemProperty -Path $AutoLogonRegPath -Name "AutoLogonCount" -Value "1" -type DWord

# Scheduled Task
$Trigger = New-ScheduledTaskTrigger -AtLogOn
$User = "$($env:ComputerName)\demouser"
$Action = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe" -Argument "-executionPolicy Unrestricted -File $LabFilesDirectory\logontask.ps1"
Register-ScheduledTask -TaskName "Setup" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest -Force

# Install Hyper-V and reboot
Write-Header "Installing Hyper-V"
Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
Install-WindowsFeature -Name Hyper-V -IncludeAllSubFeature -IncludeManagementTools -Restart

Stop-Transcript
Restart-Computer -Force 
