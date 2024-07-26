# Parametr: Ścieżka do oryginalnego pliku
param (
    [string]$filePath
)

# Sprawdź, czy plik istnieje
if (-Not (Test-Path -Path $filePath)) {
    Write-Host "Podany plik nie istnieje."
    exit
}

# Pobierz informacje o pliku
$file = Get-Item $filePath
$directory = $file.DirectoryName
$baseName = [System.IO.Path]::GetFileNameWithoutExtension($file)
$extension = $file.Extension

# Pobierz aktualną datę
$date = Get-Date
$dateString = $date.ToString("yyyyMMdd")

# Licznik plików
$counter = 1

# Lista ścieżek do wygenerowanych plików
$filePaths = @()

# Tworzenie kopii pliku
for ($i = 1; $i -le 1000; $i++) {
    $newFileName = "{0}{1}{2:0000}{3}" -f $baseName, $dateString, $counter, $extension
    $newFilePath = Join-Path $directory $newFileName

    if (Test-Path -Path $newFilePath) {
        Write-Host "Plik o nazwie $newFileName już istnieje."
    } else {
        Copy-Item -Path $filePath -Destination $newFilePath
        # Dodaj ścieżkę do listy
        $filePaths += $newFilePath
    }

    $counter++
}

# Ścieżka do pliku JSON
$jsonFilePath = Join-Path $directory "$baseName$($dateString)_generated_files.json"

# Zapisz listę ścieżek do pliku JSON
$jsonContent = $filePaths | ConvertTo-Json -Compress
Set-Content -Path $jsonFilePath -Value $jsonContent

Write-Host "Pliki zostały skopiowane i zapisane w $jsonFilePath"
pause