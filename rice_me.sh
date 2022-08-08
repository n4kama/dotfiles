#/bin/sh
#
# Run this script as any user on the system with sudo privileges
#

### OPTIONS AND VARIABLES ###

### FUNCTIONS ###

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

install_yay() {
	# Check if yay is already installed
	if [ command_exists "yay" ]
		return 1
	fi

	echo "[install_yay] yay is missing. Trying to install..."
	pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
	echo "[install_yay] yay has been installed"
}

installpkg() {
	pacman --noconfirm --needed -S "$1" >/dev/null 2>&1
}

error() {
	# Log to stderr
	echo "$1" >&2
}

error_with_exit() {
	# Log to stderr and exit with failure
	echo "$1" >&2
	exit 1
}

change_dm_ly() {
	# Check if Ly is already installed on the system. Install it otherwise
	if [ ! command_exists "ly" ]; then
		# Installing Ly. Prerequisites is : yay
		echo "[change_dm_ly] Installing Ly display manager"
		install_yay
		yay -S --noconfirm ly
		echo "[change_dm_ly] Ly has been installed"
	else
		echo "[change_dm_ly] Ly is already installed"
	fi

	# Configuring Ly
	
}

change_dm_lightdm() {
	return 0
}

change_dm() {
	# Check that only one argument is given : name of the Display Manager
	if [ "$#" != 1 ]; then
		error "[change_dm] No more/less than one argument is allowed" && return 1
	fi

	# Check for compatibility issues
	# TODO

	# Install the choosen Display Manager
	case "$1" in
		"Ly") change_dm_ly;;
		"LightDM") change_dm_lightdm;;
		*) error "[change_dm] Unknown display manager : $1" && return 1
	esac
}

main() {
	# # Check OS distribution
	# command_exists pacman ||
	# 	error_with_exit "Command not found: pacman\nAre you sure you're running this on an Arch-based distribution ?"

	# # Check if user is root. Install whiptail.
	# pacman --noconfirm --needed -Sy libnewt >/dev/null 2>&1 ||
	# 	error_with_exit "Are you sure you're running this as the root user, have an internet connection ?"
	
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
	change_dm $DISPLAY_MANAGER || error_with_exit "[Display Manager] Exiting because something went wrong while changing the display manager"

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