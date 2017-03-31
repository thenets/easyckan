# Run the following line to get English output errors message (as administrator)
#      Update-Help -UICulture en-US

# Variables
$CKAN_VERSION = "2.6.0"


# Change language to English
[Threading.Thread]::CurrentThread.CurrentUICulture = 'en-US'
#


# Check if Docker is working
try {
    $ErrorActionPreference = "Stop"
    & "C:\Program Files\Docker Toolbox\docker-machine.exe" env default | Invoke-Expression
}
catch {
    Write-Output "ERROR: Docker doens't working!"
    break
}

# Go to main docker files dir
cd installers\docker

# Check errors
function checkErrors {
    foreach ( $err in $Error ) {
        if($err -like '*SECURITY WARNING*') {
            #Write-Output "Eh soh um warning"
        }
        else {
            #Write-Output $err
            throw $err
        }
    }
}

# Build functions
function solr {
    cd ckan-solr
    docker build -t easyckan/ckan-solr:$CKAN_VERSION .
    cd ..
}
function postgres {
    cd ckan-postgres
    docker build -t easyckan/ckan-postgres:$CKAN_VERSION .
    cd ..
}
function ckan {
    cd ckan\2.6.0
    docker build -t easyckan/ckan:$CKAN_VERSION .
    cd ..
}

# Build EasyCKAN images
function build {
    $ErrorActionPreference = "SilentlyContinue"
    Write-Output "EasyCKAN building docker images..."

    Write-Output "`n`n# Build PostgreSQL image"
    postgres
    
    Write-Output "`n`n# Build Solr image"
    solr
    
    Write-Output "`n`n# Build CKAN image"
    ckan

    checkErrors
    break
}



# MAIN
build # Build images
#push # Push to Docker Hub

break