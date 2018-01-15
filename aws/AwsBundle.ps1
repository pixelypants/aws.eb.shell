function New-Bundle
{
    $stagingDirName = "bundle"
    $rootDir = Convert-Path .
    $stagingDir = $rootDir + "\$stagingDirName"
    $exclude = @('.vscode', 'aws', 'AwsBundle.ps1', 'AwsUpload.ps1', $stagingDirName)
    
    if ((Test-Path -path $stagingDir))
    {
        Write-Host "Clearing $stagingDirName folder"
        Remove-Item -Recurse -Force $stagingDir
    }
    
    New-Item $stagingDir -type directory;
    Copy-Item -Path .\aws\* -Destination $stagingDir -Recurse -Exclude $exclude
    
    Copy-Item -Path .\* -Destination $stagingDir -Exclude $exclude
    
    $bundleZip = $rootDir + "\app.zip"
    
    Compress-Archive -Path "$stagingDir\*" -DestinationPath $bundleZip
    
    Remove-Item –path $stagingDir –recurse
}

Write-Host "Creating deployment bundle."
Create-Bundle