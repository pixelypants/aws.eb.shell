function Remove-Folder
{
    Param(
        [parameter(Mandatory = $true)]
        [string]
        $StagingDir,
        [string]
        $StagingDirectorName
    )

    if ((Test-Path -path $StagingDir))
    {
        Write-Host "Clearing $StagingDirectorName folder"
        Remove-Item -Recurse -Force $StagingDir
    }
}

function New-Bundle
{
    $stagingDirName = "bundle"
    $rootDir = Convert-Path .
    if ((Get-Item -Path ".\" -Verbose).Name -eq 'aws')
    {
        $rootDir = Convert-Path ..
    }
    $stagingDir = $rootDir + "\$stagingDirName"
    $exclude = @('.vscode', 'aws', 'AwsBundle.ps1', 'AwsUpload.ps1', $stagingDirName)

    Remove-Folder -StagingDir $stagingDir -StagingDirectorName $stagingDirName

    New-Item $stagingDir -type directory;
    Copy-Item -Path "$rootDir\aws\*" -Destination $stagingDir -Recurse -Exclude $exclude
    
    Copy-Item -Path "$rootDir\*" -Destination $stagingDir -Exclude $exclude 
    
    Compress-Archive -Path "$stagingDir\*" -DestinationPath "$rootDir\app.zip" -Force
    
    Remove-Folder -StagingDir $stagingDir -StagingDirectorName $stagingDirName
}

Write-Host "Creating deployment bundle."
New-Bundle