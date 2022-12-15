#/bin/sh
#
# Run this script as any user on the system with sudo privileges
#

### OPTIONS AND VARIABLES ###

# Name of the user who called this script 
USERNAME=$(logname)

# Useful path & directories
SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname "$SCRIPT_PATH")
HOMEDIR="/home/$USERNAME"

### FUNCTIONS ###

command_exists() {
  command -v "$@" >/dev/null 2>&1
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

install_yay() {
	# Check if yay is already installed
	command_exists "yay" && return 0

	echo "[install_yay] yay is missing. Trying to install..."
	pacman -S --noconfirm --needed git base-devel >/dev/null 2>&1 \
	&& cd /opt \
	&& git clone --quiet https://aur.archlinux.org/yay.git \
	&& chown -R $USERNAME:$USERNAME ./yay \
	&& cd yay \
	&& sudo -u $USERNAME makepkg -si --noconfirm >/dev/null 2>&1 \
	|| (error "[install_yay] yay could NOT be installed !"; return 1)
	echo "[install_yay] yay has been installed in /opt"
}

change_dm_lightdm() {
	# Check if LightDM is already installed on the system. Install it otherwise
	if command_exists "lightdm"; then
		echo "[change_dm_lightdm] LightDM is already installed"
	else
		# Installing Ly. Prerequisites : yay
		echo "[change_dm_lightdm] LightDM display manager is missing. Trying to install..."
		pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter >/dev/null 2>&1 \
		|| (error "[ERROR][change_dm_lightdm] LightDM could NOT be installed !"; return 1)
		echo "[change_dm_lightdm] LightDM has been installed"
	fi

	# Check if another dm is already configured and disable it if so
	echo "[change_dm_lightdm] Check if another dm is already installed and disable it if so"
	systemctl status display-manager.service >/dev/null 2>&1 \
	&& systemctl disable display-manager.service >/dev/null 2>&1 \
	&& error_with_exit "[ERROR][change_dm_lightdm] Could not disable previous display-manager"

	# Configuring LightDM
	systemctl enable lightdm >/dev/null 2>&1
}

change_dm_ly() {
	# Check if Ly is already installed on the system. Install it otherwise
	if command_exists "ly"; then
		echo "[change_dm_ly] Ly is already installed"
	else
		# Installing Ly. Prerequisites : yay
		echo "[change_dm_ly] Ly display manager is missing. Trying to install..."
		install_yay || return 1
		sudo -u $USERNAME yay -S --noconfirm ly >/dev/null 2>&1 \
		|| (error "[ERROR][change_dm_ly] Ly could NOT be installed !"; return 1)
		echo "[change_dm_ly] Ly has been installed"
	fi

	# Check if another dm is already configured and disable it if so
	echo "[change_dm_ly] Check if another dm is already installed and disable it if so"
	systemctl status display-manager.service >/dev/null 2>&1 \
	&& systemctl disable display-manager.service >/dev/null 2>&1 \
	&& error_with_exit "[ERROR][change_dm_ly] Could not disable previous display-manager"

	# Configuring Ly
	systemctl enable ly >/dev/null 2>&1
}

change_wm_bspwm() {
	# TODO
	return 1
}

change_wm_dwm() {
	# TODO
	return 1
}

change_wm_i3gaps() {
	# Check if i3-gaps is already installed on the system. Install it otherwise
	if command_exists "i3-gaps"; then
		echo "[change_wm_i3gaps] i3-gaps is already installed"
	else
		# Installing i3-gaps.
		echo "[change_wm_i3gaps] i3-gaps is missing. Trying to install..."
		pacman -S --noconfirm --needed i3-gaps i3status i3lock dmenu numlockx ttf-dejavu >/dev/null 2>&1 \
		|| (error "[ERROR][change_wm_i3gaps] i3-gaps could NOT be installed !"; return 1)
		echo "[change_wm_i3gaps] i3-gaps has been installed"
	fi

	# Check if another window manager is already configured and disable it if so
	# TODO

	# Configuring i3-gaps
	# TODO
}

change_wm_qtile() {
	# TODO
	return 1
}

change_statusbar_dwmbar() {
	# TODO
	return 1
}

change_statusbar_i3bar() {
	# i3 bar comes installed with i3/i3-gaps
	# check if it is already installed and/or currently used
	command_exists "i3" || return 1
	return 0
}

change_term_alactritty() {
	# Check if Alacritty is already installed on the system. Install it otherwise
	if command_exists "alacritty"; then
		echo "[change_term_alactritty] Alacritty is already installed"
	else
		# Installing Alacritty.
		echo "[change_term_alactritty] Alacritty is missing. Trying to install..."
		pacman -S --noconfirm --needed alacritty >/dev/null 2>&1 \
		|| (error "[ERROR][change_term_alactritty] Alacritty could NOT be installed !"; return 1)
		echo "[change_term_alactritty] Alacritty has been installed"
	fi

	# Check if another terminal is already configured and disable it if so
	# TODO

	# Configuring Alacritty
	# TODO
}

change_shell_bash() {
	# TODO
	command_exists "bash" || return 1
	return 0
}

change_shell_fish() {
	# TODO
	return 1
}

change_shell_zsh() {
	# TODO
	return 1
}

change_editor_vim() {
	# Check if Vim is already installed on the system. Install it otherwise
	if command_exists "vim"; then
		echo "[change_editor_vim] Vim is already installed"
	else
		# Installing Vim.
		echo "[change_editor_vim] Vim is missing. Trying to install..."
		pacman -S --noconfirm --needed vim >/dev/null 2>&1 \
		|| (error "[ERROR][change_editor_vim] Vim could NOT be installed !"; return 1)
		echo "[change_editor_vim] Vim has been installed"
	fi

	# Configuring Vim
	echo "$SCRIPT_PATH"
	echo "$BASEDIR"
	ln -nsf "$BASEDIR/config/vimrc" "$HOMEDIR/.vimrc" >/dev/null 2>&1 \
	|| (error "[ERROR][change_editor_vim] Vim could NOT be configured !"; return 1)
	echo "[change_editor_vim] Vim has been configured in : $HOMEDIR/.vimrc"
}

change_dm() {
	# Check that only one argument is given : name of the Display Manager
	if [ "$#" != 1 ]; then
		error "[change_dm] No more/less than one argument is allowed" && return 1
	fi

	# Check for compatibility issues
	# TODO

	# Change the Display Manager
	case "$1" in
		"LightDM") change_dm_lightdm;;
		"Ly") change_dm_ly;;
		*) error "[change_dm] Unknown display manager : $1" && return 1
	esac
}

change_wm() {
	# Check that only one argument is given : name of the Window Manager
	if [ "$#" != 1 ]; then
		error "[change_wm] No more/less than one argument is allowed" && return 1
	fi

	# Check for compatibility issues
	# TODO

	# Change the Window Manager
	case "$1" in
		"bspwm") change_wm_bspwm;;
		"dwm") change_wm_dwm;;
		"i3-gaps") change_wm_i3gaps;;
		"QTile") change_wm_qtile;;
		*) error "[change_wm] Unknown window manager : $1" && return 1
	esac
}

change_statusbar() {
	# Check that only one argument is given : name of the Status Bar
	if [ "$#" != 1 ]; then
		error "[change_statusbar] No more/less than one argument is allowed" && return 1
	fi

	# Check for compatibility issues
	# TODO

	# Change the Window Manager
	case "$1" in
		"dwm-bar") change_statusbar_dwmbar;;
		"i3bar") change_statusbar_i3bar;;
		*) error "[change_statusbar] Unknown status bar : $1" && return 1
	esac
}

change_term() {
	# Check that only one argument is given : name of the Terminal
	if [ "$#" != 1 ]; then
		error "[change_term] No more/less than one argument is allowed" && return 1
	fi

	# Check for compatibility issues
	# TODO

	# Change the Terminal
	case "$1" in
		"Alacritty") change_term_alactritty;;
		*) error "[change_term] Unknown terminal : $1" && return 1
	esac
}

change_shell() {
	# Check that only one argument is given : name of the Shell
	if [ "$#" != 1 ]; then
		error "[change_shell] No more/less than one argument is allowed" && return 1
	fi

	# Check for compatibility issues
	# TODO

	# Change the Terminal
	case "$1" in
		"Bash") change_shell_bash;;
		"Fish") change_shell_fish;;
		"Zsh") change_shell_zsh;;
		*) error "[change_shell] Unknown shell : $1" && return 1
	esac
}

main() {
	# Check OS distribution
	command_exists pacman ||
		error_with_exit "Command not found: pacman\nAre you sure you're running this on an Arch-based distribution ?"

	# Check if user is root. Install whiptail.
	pacman --noconfirm --needed -Sy libnewt >/dev/null 2>&1 ||
		error_with_exit "Are you sure you're running this as the root user, have an internet connection ?"
	
	# Select Display server and Login manager
	# Default is set on 'Ly'
	DISPLAY_MANAGER=$(whiptail --title "Rice me up !" \
	--radiolist "Display server and/or Login manager" 15 65 2 \
	"LightDM" "GUI display manager with Xorg/X11" OFF \
	"Ly" "TUI display manager with Xorg/X11" ON \
	3>&1 1>&2 2>&3 3>&1)

	# Select Window manager
	# Default is set on 'dwm'
	WINDOW_MANAGER=$(whiptail --title "Rice me up !" \
	--radiolist "Window manager" 15 65 4 \
	"bspwm" "Window manager based on binary trees" OFF \
	"dwm" "Suckless dynamic window manager. Comes with vanilla dwm status bar" OFF \
	"i3-gaps" "i3 but with gaps ! Comes with i3bar" ON \
	"QTile" "Window manager configured in python. Comes with vanilla qtile bar" OFF \
	3>&1 1>&2 2>&3 3>&1)

	# Select Status bar
	case "$WINDOW_MANAGER" in
		"bspwm") 	STATUS_BAR=$(whiptail --title "Rice me up !" \
								--radiolist "Status bar" 15 65 1 \
								"polybar" "Polybar project" ON \
								3>&1 1>&2 2>&3 3>&1
								);;
		"dwm") STATUS_BAR="dwm-bar";;
		"i3-gaps") STATUS_BAR="i3bar";;
		"QTile") STATUS_BAR="qtile-bar";;
	esac

	# Select Terminal
	TERMINAL=$(whiptail --title "Rice me up !" \
	--radiolist "Terminal" 15 65 2 \
	"Alacritty" "" ON \
	"rxvt-unicode" "" OFF \
	3>&1 1>&2 2>&3 3>&1)

	# Select Shell
	SHELL=$(whiptail --title "Rice me up !" \
	--radiolist "Shell" 15 65 3 \
	"Bash" "" ON \
	"Fish" "" OFF \
	"Zsh" "" OFF \
	3>&1 1>&2 2>&3 3>&1)

	# Select Editor
	EDITOR=$(whiptail --title "Rice me up !" \
	--radiolist "Editor" 15 65 1 \
	"vim" "" ON \
	3>&1 1>&2 2>&3 3>&1)

	# Select Font
	FONT=$(whiptail --title "Rice me up !" \
	--radiolist "Font" 15 65 1 \
	"fixme" "" ON \
	3>&1 1>&2 2>&3 3>&1)

	clear

	echo "[Display Manager] Changing to $DISPLAY_MANAGER"
	change_dm $DISPLAY_MANAGER || error_with_exit "[Display Manager] Exiting because something went wrong while changing the display manager"

	echo "[Window Manager] Changing to $WINDOW_MANAGER"
	change_wm $WINDOW_MANAGER || error_with_exit "[Window Manager] Exiting because something went wrong while changing the window manager"

	echo "[Status Bar] Changing to $STATUS_BAR"
	change_statusbar $STATUS_BAR || error_with_exit "[Status Bar] Exiting because something went wrong while changing the status bar"

	echo "[Terminal] Changing to $TERMINAL"
	change_term $TERMINAL || error_with_exit "[Terminal] Exiting because something went wrong while changing the terminal"

	echo "[Shell] Changing to $SHELL"
	change_shell $SHELL || error_with_exit "[Shell] Exiting because something went wrong while changing the shell"

	echo "[Editor] Changing to $EDITOR"
	change_editor_vim || error_with_exit "[Editor] Exiting because something went wrong while changing the editor"

	echo "[Font] Changing to $FONT"
	echo "[Font] no font available" || error_with_exit "[Font] Exiting because something went wrong while changing the font"
}

### SCRIPT ###

main