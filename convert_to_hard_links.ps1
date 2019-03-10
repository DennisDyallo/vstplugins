function CleanShortcutNames($Path){
	Get-ChildItem $Path | Rename-Item -NewName { $_.Name -Replace '(.*\.(dll|vst3))(.*)(\.lnk)','$1$4'}
}

$symlinkPathList = Get-ChildItem -Recurse -Filter "*.lnk" | Where-Object { $_.Attributes -ne "Directory"} | select -ExpandProperty FullName
$obj = New-Object -ComObject WScript.Shell 

ForEach($existingLinkPath in $symlinkPathList) { 
	CleanShortcutNames $existingLinkPath
	
	$linkObj = $obj.CreateShortcut($existingLinkPath) 
	[string]$existingLinkTargetPath = $linkObj.TargetPath
	
	$targetFileExtension = Get-Item $linkObj.TargetPath | Select -ExpandProperty Extension
	
	"Making link: " + $existingLinkPath.Replace(".lnk","") + " to $existingLinkTargetPath"
	New-Item -ItemType HardLink -Path $existingLinkPath.Replace(".lnk","") -Value $existingLinkTargetPath
}

