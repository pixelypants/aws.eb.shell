function Publish-Bundle
{
    Param(
        [parameter(Mandatory = $true)]
        [string]
        $AppName,
        [string]
        $S3BucketName,
        [string]
        $S3BucketFolderName,
        [string]
        $VersionLabel
    )
	
    $s3path = "$S3BucketFolderName/$VersionLabel.zip"
    Write-S3Object -BucketName $S3BucketName -Key $s3path -File ..\app.zip
    New-EBApplicationVersion -ApplicationName $AppName -VersionLabel $VersionLabel -SourceBundle_S3Bucket $S3BucketName -SourceBundle_S3Key $s3path
}

Write-Host "Publish and register new version."
Publish-Bundle -VersionLabel "v1.02" -AppName "roger-eb-app" -S3BucketName "elasticbeanstalk-ap-southeast-2-200053207227" -S3BucketFolderName "ubet-api-app-versions"