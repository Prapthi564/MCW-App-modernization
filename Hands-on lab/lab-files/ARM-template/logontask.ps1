Start-Transcript -Path C:\WindowsAzure\Logs\logontask.txt -Append

# Define the download URL and the local file path
$downloadUrl = "https://download.microsoft.com/download/E/4/7/E4771905-1079-445B-8BF9-8A1A075D8A10/IntegrationRuntime_5.48.9076.1.msi"
$installerPath = "$env:TEMP\IntegrationRuntime.msi"
 
# Download the MSI file
Write-Output "Downloading the MSI package..."
Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath
 
# Check if the file was downloaded successfully
if (Test-Path $installerPath) {
    Write-Output "Download completed. Installing the package..."
 
    # Install the MSI package silently
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$installerPath`" /quiet /norestart" -Wait
 
    Write-Output "Installation completed."
 
    # Clean up the installer file if desired
    Remove-Item -Path $installerPath -Force
} else {
    Write-Output "Failed to download the MSI package."
}

Unregister-ScheduledTask -TaskName "Setup" -Confirm:$false
