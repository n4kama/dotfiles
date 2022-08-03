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
	# Check OS distribution
	command_exists pacman ||
		error "Command not found: pacman\nAre you sure you're running this on an Arch-based distribution ?"

	# Check if user is root. Install whiptail.
	pacman --noconfirm --needed -Sy libnewt >/dev/null 2>&1 ||
		error "Are you sure you're running this as the root user, have an internet connection ?"
	

}

### SCRIPT ###

main