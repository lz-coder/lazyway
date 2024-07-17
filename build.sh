#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

# Install VSCode
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
rpm-ostree install code && rm -rf /etc/yum.repos.d/vscode.repo

rpm-ostree override remove noopenh264 --install openh264
rpm-ostree install gh distrobox podman-compose gstreamer1-plugin-openh264 podman-docker podman-tui helix zsh git-cola
rpm-ostree override remove firefox firefox-langpacks --install qutebrowser

sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf
systemctl enable rpm-ostreed-automatic.timer
sed -i '/^PRETTY_NAME/s/Silverblue/Lazyway/' /usr/lib/os-release

