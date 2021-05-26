$ErrorActionPreference = "Stop" #using namespace System.Linq
function Format-Template { param( [string]$Template, [hashtable]$Dict)
    $formated = $Template
    foreach ($kvp in $Dict.GetEnumerator()) {
        $formated = $formated -replace "{$($kvp.Key)}", $kvp.Value
        $formated = $formated -replace "{Label-$($kvp.Key)}", ("$($kvp.Key): $($kvp.Value)", "")[$kvp.Value -eq ""]  
    }
    return $formated
}

$build = ".build"

Remove-Item .\.build\* -Recurse -Force

Copy-Item -Path ".\src\imgs\*" -Destination "$build\" 

# $filetemplate = Get-Content ".\src\core\file.html" -Raw
$dict = @{ 
    "Index" = Get-Content ".\src\core\index.html" -Raw;
    "Head" = Get-Content ".\src\core\head.html" -Raw; 
    "Body" = Get-Content ".\src\core\body.html" -Raw; 
    "JS" = Get-Content ".\src\core\main.js" -Raw; 
    "CSS" = Get-Content ".\src\core\theme.css" -Raw; 
}

$indexPage = Format-Template -Template $dict["Index"] -Dict $dict 
Set-Content -Path "$build/index.html" -Value $indexPage

$mainJs = Format-Template -Template $dict["JS"] -Dict $dict 
Set-Content -Path "$build/main.js" -Value $mainJs

$themeCss = Format-Template -Template $dict["CSS"] -Dict $dict 
Set-Content -Path "$build/theme.css" -Value $themeCss
