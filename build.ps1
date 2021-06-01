$ErrorActionPreference = "Stop" 
$envs = Get-ChildItem env:
Write-Output $envs
Write-Output $args
$build = ".build"

function Add-Homepage { param()
    Write-Output "Build-HomePage"
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
    
}

function Format-Template { param( [string]$Template, [hashtable]$Dict)
    $formated = $Template
    foreach ($kvp in $Dict.GetEnumerator()) {
        $formated = $formated -replace "{$($kvp.Key)}", $kvp.Value
        $formated = $formated -replace "{Label-$($kvp.Key)}", ("$($kvp.Key): $($kvp.Value)", "")[$kvp.Value -eq ""]  
    }
    return $formated
}

function Set-Transforms { param([string]$dst)
    $files = Get-ChildItem -Path $dst -r -include "*.js","*.md","*.html"
    foreach ($file in $files) {
        $a = $file.fullname;
        Write-Output $a
        Foreach-Object {  ( Get-Content $a ) | Foreach-Object { $_.replace("/examples/","/scenes/") } | Set-Content $a -Force }
    }
}

function Add-Folder { param( [string]$src, [string]$dst)
    Remove-Item $dst -Recurse -Force -Confirm:$false -ErrorAction Ignore
    Copy-Item -Path $src -Destination $dst -Recurse -Force
    Set-Transforms $dst
}



function Add-Website { param( [array]$req)
    Write-Output $req
    foreach ($item in $req) {        
        Add-Folder $item.src $item.dst
    }

    # Add-Homepage
}

$req = @(
@{src=".\src\build\"; dst=".\$build\build\"},
@{src=".\src\js\"; dst=".\$build\js\"},
@{src=".\src\imgs\"; dst=".\$build\imgs\"},
@{src=".\src\scenes\"; dst=".\$build\scenes\"},
@{src=".\src\editor\"; dst=".\$build\editor\"}
)

Add-Website $req
