#!/bin/bash
echo "sudo available: $(command -v sudo || echo NO)"
id -un
whoami
echo "--- apt check ---"
which apt-get
echo "--- can sudo non-interactive? ---"
sudo -n true 2>&1 && echo "SUDO-NOPASS-OK" || echo "SUDO-NEEDS-PASSWORD"
