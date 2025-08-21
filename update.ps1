$FE_REPO = "https://github.com/julioojordan/mathApp.git"
$BE_REPO = "https://github.com/julioojordan/mathApp-service.git"

Write-Host "Menghapus folder lama..."
Remove-Item -Recurse -Force mathApp, mathApp-service -ErrorAction SilentlyContinue

Write-Host "Cloning repo frontend ($FE_REPO)..."
git clone $FE_REPO

Write-Host "Cloning repo backend ($BE_REPO)..."
git clone $BE_REPO

Write-Host "Repositori Updated Successfully!"
