#/bin/sh
#
# Run this script as any user on the system with sudo privileges
#

### OPTIONS AND VARIABLES ###

### FUNCTIONS ###

command_exists() {
  command -v "$@" >/dev/null 2>&1
}
 
installpkg() {
	pacman --noconfirm --needed -S "$1" >/dev/null 2>&1
}

error() {
	# Log to stderr and exit with failure
	echo "$1" >&2
	exit 1
}

main() {
	# # Check OS distribution
	# command_exists pacman ||
	# 	error "Command not found: pacman\nAre you sure you're running this on an Arch-based distribution ?"

	# # Check if user is root. Install whiptail.
	# pacman --noconfirm --needed -Sy libnewt >/dev/null 2>&1 ||
	# 	error "Are you sure you're running this as the root user, have an internet connection ?"
	
	# Select Display server and Login manager
	# Default is set on 'Ly'
	DISPLAY_MANAGER=$(whiptail --title "Rice me up !" \
	--radiolist "Display server and/or Login manager" 15 65 2 \
	"Ly" "TUI display manager with Xorg/X11" ON \
	"LightDM" "GUI display manager with Xorg/X11" OFF \
	3>&1 1>&2 2>&3 3>&1)

	# Select Window manager
	# Default is set on 'dwm'
	WINDOW_MANAGER=$(whiptail --title "Rice me up !" \
	--radiolist "Window manager" 15 65 2 \
	"i3-gaps" "i3 but with gaps !" OFF \
	"dwm" "Suckless dynamic window manager" ON \
	"QTile" "Window manager configured in python" OFF \
	"bspwm" "Window manager based on binary trees" OFF \
	3>&1 1>&2 2>&3 3>&1)

	# Select Status bar
	STATUS_BAR=$(whiptail --title "Rice me up !" \
	--radiolist "Status bar" 15 65 2 \
	"i3bar" "i3 status bar" OFF \
	"dwm-bar" "dwm status bar" ON \
	3>&1 1>&2 2>&3 3>&1)

	# Select Terminal
	TERMINAL=$(whiptail --title "Rice me up !" \
	--radiolist "Terminal" 15 65 2 \
	"Alacritty" "" ON \
	3>&1 1>&2 2>&3 3>&1)

	# Select Shell
	SHELL=$(whiptail --title "Rice me up !" \
	--radiolist "Shell" 15 65 2 \
	"Bash" "" ON \
	"Zsh" "" OFF \
	"Fish" "" OFF \
	3>&1 1>&2 2>&3 3>&1)

	# Select Editor
	EDITOR=$(whiptail --title "Rice me up !" \
	--radiolist "Editor" 15 65 2 \
	"vim" "" ON \
	3>&1 1>&2 2>&3 3>&1)

	# Select Font
	FONT=$(whiptail --title "Rice me up !" \
	--radiolist "Font" 15 65 2 \
	"fixme" "" ON \
	3>&1 1>&2 2>&3 3>&1)
	
	echo "[Display Manager] Changing to $DISPLAY_MANAGER"
	# FIXME

	echo "[Window Manager] Changing to $WINDOW_MANAGER"
	# FIXME

	echo "[Status Bar] Changing to $STATUS_BAR"
	# FIXME

	echo "[Terminal] Changing to $TERMINAL"
	# FIXME

	echo "[Shell] Changing to $SHELL"
	# FIXME

	echo "[Editor] Changing to $EDITOR"
	# FIXME

	echo "[Font] Changing to $FONT"
	# FIXME
}

### SCRIPT ###

main