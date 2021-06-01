# $ErrorActionPreference = "Stop" 
#$envs = (Get-ChildItem env:)
$lines = @()

$lines += "CLEAN            $env:CLEAN"
$lines += "FFMPEG_PATH      $env:FFMPEG_PATH"
$lines += "FFPROBE_PATH     $env:FFPROBE_PATH"

# foreach ($kvp in $envs) {
#     $lines +="$($kvp.Key) $($kvp.Value)" # TIL += creates a new array with this element at the end. 
# }
Write-Output $lines