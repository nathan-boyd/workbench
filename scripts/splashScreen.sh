#!/usr/bin/env bash

clear

echo ""
neofetch

fortune /opt/fortune | cowsay -f "$(ls /usr/share/cowsay/cows | sort -R | head -1)" 
