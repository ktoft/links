# Possible export paths (network shares with different IPs)
$IPAddresses = @("192.168.1.10", "192.168.1.11", "192.168.1.12", "192.168.1.13")
$SharePath = "\HyperVExports\MyVM"
$ExportPath = $null

# Find the first available export path
foreach ($ip in $IPAddresses) {
    $path = "\\$ip$SharePath"
    if (Test-Path $path) {
        $ExportPath = $path
        break
    }
}

if (-not $ExportPath) {
    Write-Error "No available export path found."
    exit
}

$ImportPath = "C:\HyperV\ImportedVMs"

# Copy exported VM files to local disk
Copy-Item -Path $ExportPath -Destination $ImportPath -Recurse

# Find the VM configuration file (XML)
$VMConfig = Get-ChildItem -Path $ImportPath -Recurse -Filter *.xml | Select-Object -First 1

# Import the VM
Import-VM -Path $VMConfig.FullName

# (Optional) Start the imported VM
# Start-VM -Name "MyVM"