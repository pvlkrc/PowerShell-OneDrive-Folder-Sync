# Credentials
$username = 'name@yourdomain.tlc'
$pass = 'password'

# Destination path on OneDrive
$dest_path = 'Documents/sync_folder'

# Source folder
$sourceFolder = 'C:\source_folder'

$files = Get-ChildItem -Path $sourceFolder -Recurse -File

$securePass = ConvertTo-SecureString $pass -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($username, $securePass)

# URL of user OneDrive
Connect-PnPOnline https://yourdomain-my.sharepoint.com/personal/username_yourdomain_tld -Credentials $cred

# Loop through source folder and recursively upload files and folders on OneDrive
foreach ($file in $files) {

        $filePath = $file.FullName
        $relativePath = $file.FullName.Substring($sourceFolder.Length + 1).Replace('\', '/')
        $folderPath = $dest_path + $relativePath

        # Ensure the folder path exists in SharePoint, if not create it
        $folder = $dest_path + $file.DirectoryName.Substring($sourceFolder.Length).Replace('\', '/')
        Resolve-PnPFolder -SiteRelativePath $folder

        # Upload the file
        Add-PnPFile -Path $filePath -Folder $folder
}

Disconnect-PnPOnline
