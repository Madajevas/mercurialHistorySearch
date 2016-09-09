Param(
  [string]$file,
  [string]$search
)

$log = hg log $file | select

$log = [System.String]::Join("`n", $log)

$changes = $log -split "`n`n"
[array]::Reverse($changes);

$pattern = "changeset:\s*(?<revision>\d+)(.|\n)*summary:\s*(?<message>.*)"

$lastRevision = 0
foreach ($change in $changes)
{
    if ($change -match $pattern)
    {
        $diff = hg diff -r $lastRevision -r $matches["revision"] $file
        $lastRevision = $matches["revision"]

        $joined = [String]::Join("`n", $diff)

        if ($joined -like "*$search*")
        {
            Write-Host "Change was made in revision $lastRevision"
        }
    }
}
