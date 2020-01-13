$env:PATH += ";C:\texlive\bin\win32"

# See if there is a cached version of TL available
if (-Not (Get-Command texlua -errorAction SilentlyContinue))
{
  Invoke-WebRequest -Uri "https://mirrors.rit.edu/CTAN/systems/texlive/tlnet/install-tl.zip" `
                    -OutFile "install-tl.zip"
  Expand-Archive "install-tl.zip" -DestinationPath .
  Set-Location "install-tl-20*"
  Invoke-WebRequest -Uri "https://intellisenselab.ml/install-tl-advanced.bat" `
                    -OutFile "install-tl-advanced.bat"
  # Install a minimal system
  .\install-tl-advanced.bat -no-gui `
                            -profile     ../.appveyor/texlive/texlive.profile `
                            -repository  https://mirrors.rit.edu/CTAN/systems/texlive/tlnet
  Set-Location ..
}

# Change default package repository
tlmgr option repository https://mirrors.rit.edu/CTAN/systems/texlive/tlnet

# Packages
tlmgr install scheme-full

# Keep no backups (not required, simply makes cache bigger)
tlmgr option -- autobackup 0

# Update the TL install but add nothing new
tlmgr update --self --all --no-auto-install
