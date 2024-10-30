#!/bin/bash

echo "This must be run as root or a user with sudo privileges"

setsudoer () {
  read -p "Type your username, be exact, and press Enter: " ANS
  sudo usermod -aG sudo "$ANS"
}

setsudoer
