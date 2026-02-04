#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    glu      \
    libdecor \
    libvpx   \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package gtk2

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of NBlood..."
echo "---------------------------------------------------------------"
REPO="https://github.com/NBlood/NBlood"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./NBlood
echo "$VERSION" > ~/version

cd ./NBlood
make blood -j$(nproc)
mv -v nblood /usr/bin
mv -v nblood.pk3 /usr/share/games/nblood 
cp -r source/blood/rsrc/game_icon.ico /usr/share/pixmaps/nblood.ico
