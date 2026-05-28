# Script for renaming AmneziaVPN to PhasmalVPN

$replacements = @{
    'AmneziaVPN' = 'PhasmalVPN'
    'Amnezia VPN' = 'Phasmal VPN'
    'amnezia-vpn' = 'phasmal-vpn'
    'org.amnezia' = 'com.phasmal'
    'com.amnezia' = 'com.phasmal'
    'amnezia.org' = 'phasmalvpn.com'
    'https://github.com/amnezia-vpn/amnezia-client' = 'https://github.com/Fl1ck5h0t/Phasmal-client'
}

$excludeDirs = @('.git', 'build', 'conan', '.conan', 'node_modules', '.gradle')
$includeExtensions = @('*.cpp', '*.h', '*.c', '*.hpp', '*.cc', '*.cxx',
                       '*.qml', '*.js', '*.ts', '*.kt', '*.swift',
                       '*.cmake', '*.txt', '*.md', '*.json', '*.xml',
                       '*.plist', '*.in', '*.gradle', '*.kts', '*.entitlements',
                       '*.yml', '*.yaml', '*.sh', '*.bat', '*.py')

Write-Host "Starting project rename..." -ForegroundColor Green

$files = Get-ChildItem -Path $PSScriptRoot -Recurse -File -Include $includeExtensions |
    Where-Object {
        $path = $_.FullName
        -not ($excludeDirs | Where-Object { $path -like "*\$_\*" })
    }

$totalFiles = $files.Count
$processedFiles = 0
$modifiedFiles = 0

foreach ($file in $files) {
    $processedFiles++
    Write-Progress -Activity "Processing files" -Status "$processedFiles of $totalFiles" -PercentComplete (($processedFiles / $totalFiles) * 100)

    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8 -ErrorAction Stop
        $originalContent = $content

        foreach ($key in $replacements.Keys) {
            $content = $content -replace [regex]::Escape($key), $replacements[$key]
        }

        if ($content -ne $originalContent) {
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
            $modifiedFiles++
            Write-Host "Modified: $($file.FullName)" -ForegroundColor Cyan
        }
    }
    catch {
        Write-Host "Error in file $($file.FullName): $_" -ForegroundColor Red
    }
}

Write-Progress -Activity "Processing files" -Completed

Write-Host "`n=== Results ===" -ForegroundColor Green
Write-Host "Processed files: $processedFiles"
Write-Host "Modified files: $modifiedFiles"
Write-Host "`nRename completed!" -ForegroundColor Green
