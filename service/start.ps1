param (
    [string]$serviceVersion = "v1.0"
)

# Check server version
try {
    if ($serviceVersion -ne 'latest' -and $serviceVersion -ne 'develop') {
        $pattern = "^v\d+\.\d+(\.\d+)?$"
        if ($serviceVersion -notmatch $pattern) {
            throw "Invalid version format. Expected 'v*.*' or 'v*.*.*' or develop or latest."
        }
    } 
} catch {
    Write-Error $_.Exception.Message
    exit 1
}

# Define the URL to query Docker tags based on the server version.
$dockerTagQueryUrl = "https://hub.docker.com/v2/repositories/xiaozirun/leap-ledger/tags?page_size=25&page=1&ordering=last_updated&name=$serviceVersion"
$imageUrl = "xiaozirun/leap-ledger"

# This function queries Docker Hub to find the latest available service image that matches the provided version.
function FindLatestAvailableServiceImage {
    param (
        [string]$url
    )
    
    try {
        # Get the available Docker image tags.
        $response = Invoke-RestMethod -Uri $url -Method Get -ErrorAction Stop
        if ($response.results -is [array] -and $response.results.Count -ne 0) {
            return "$($response.results[0].name)"
        } else {
            throw "No available service image found. Please submit an issue: https://github.com/ZiRunHua/LeapLedger-App/issues"
        }
    } catch {
        Write-Error "Error: $($_.Exception.Message)"
        exit 1
    }
}

# If the provided version is 'latest' or 'develop', use it directly.
# Otherwise, find the latest available patch version for the provided major.minor version.
$version = if ($serviceVersion -eq 'latest' -or $serviceVersion -eq 'develop') {
    "$serviceVersion"
} else {
    # Note: The actual version to be used might differ from the provided version.
    # For example, if the input is 'v1.0', this script will look for the latest 'v1.0.x' patch version.
    FindLatestAvailableServiceImage $dockerTagQueryUrl
}

Write-Output "Found service image version: $version"

$env:SERVICE_VERSION = $version
$imageUrl = "$imageUrl"+":"+"$version"
# Pull the Docker image.
docker pull "$imageUrl"

# Run the Docker container in detached mode and capture the container ID.
$dockerID = (docker run -d $imageUrl).Trim()
$dockerID = $dockerID.TrimEnd("`n", "`r", "")
# Copy necessary configuration files from the Docker container.
$path = [string]::Concat($dockerID, ":go/LeapLedger/docs")
docker cp "$path" "./docs"
$path = [string]::Concat($dockerID, ":go/LeapLedger/docker")
docker cp "$path" "./docker"
$path = [string]::Concat($dockerID, ":go/LeapLedger/docker-compose.yaml")
docker cp "$path" "./docker-compose.yaml"

# Stop and remove the temporary container.
docker stop $dockerID | Out-Null
docker rm $dockerID | Out-Null

# Start the MySQL server and the main application.
docker-compose up -d leap-ledger-mysql

while (-not (docker-compose logs leap-ledger-mysql | Select-String "ready for connections")) {
    Write-Output "Waiting for MySQL to be ready..."
    Start-Sleep -Seconds 3
}

docker-compose up -d

Write-Output "Server started"