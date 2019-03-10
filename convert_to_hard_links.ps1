$symlinkPathList = Get-ChildItem -Recurse -Filter "*.lnk" | Where-Object { $_.Attributes -ne "Directory"} | select -ExpandProperty FullName
$obj = New-Object -ComObject WScript.Shell 
Write-Host $symlinkPathList

ForEach($existingLinkPath in $symlinkPathList) { 
	$linkObj = $obj.CreateShortcut($existingLinkPath) 
	[string]$existingLinkTargetPath = $linkObj.TargetPath
	
	$targetFileExtension = Get-Item $linkObj.TargetPath | Select -ExpandProperty Extension
	
	"Making link: " + $existingLinkPath.Replace(".lnk","") + " to $existingLinkTargetPath"
	New-Item -ItemType HardLink -Path $existingLinkPath.Replace(".lnk","") -Value $existingLinkTargetPath
}
