#!/usr/bin/env bash
set -euo pipefail

info() { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
error() { printf '\033[1;31m[ERR ]\033[0m %s\n' "$*" >&2; }

INTERACTIVE=1
LOG_FILE=""

while [[ $# -gt 0 ]]; do
	case "$1" in
	-y | --yes | --non-interactive)
		INTERACTIVE=0
		shift
		;;
	--log)
		LOG_FILE="$HOME/install-dotnet.log"
		shift
		;;
	--log-file)
		LOG_FILE="$2"
		shift 2
		;;
	--log-file=*)
		LOG_FILE="${1#*=}"
		shift
		;;
	-h | --help)
		cat <<'EOF'
Usage: install-dotnet-linux.sh [OPTIONS]

Installs:
  - .NET SDKs (default: 6.0, 8.0, 9.0)
  - Global tools (ef, format, outdated, aspnet-codegenerator, script, sonarscanner, repl)
  - OmniSharp (VS Code C# extension + OmniSharp server on Arch)

Options:
  -y, --yes, --non-interactive   Use defaults, do not ask interactive questions.
  --log                          Log to ~/install-dotnet.log
  --log-file PATH                Log to PATH
  -h, --help                     Show this help.

Examples:
  ./install-dotnet-linux.sh
  ./install-dotnet-linux.sh --yes --log
EOF
		exit 0
		;;
	*)
		warn "Ignoring unknown option: $1"
		shift
		;;
	esac
done

DISTRO=""
PRETTY=""

detect_distro() {
	if [[ -r /etc/os-release ]]; then
		# shellcheck source=/dev/null
		. /etc/os-release
	else
		error "/etc/os-release not found; cannot detect distribution."
		exit 1
	fi

	if [[ "${ID,,}" == "ubuntu" ]] || [[ "${ID_LIKE:-}" == *"ubuntu"* ]] || [[ "${ID_LIKE:-}" == *"debian"* ]]; then
		DISTRO="ubuntu"
	elif [[ "${ID,,}" == "arch" ]] || [[ "${ID_LIKE:-}" == *"arch"* ]]; then
		DISTRO="arch"
	fi

	if [[ -z "$DISTRO" ]]; then
		error "Unsupported distro: ID='${ID:-unknown}' ID_LIKE='${ID_LIKE:-unknown}'."
		error "Supported: Ubuntu-like, Arch-like."
		exit 1
	fi

	PRETTY="${PRETTY_NAME:-$ID}"
	info "Detected distribution: $DISTRO ($PRETTY)"
}

download_file() {
	local url="$1" dest="$2"
	if command -v curl >/dev/null 2>&1; then
		curl -sSL "$url" -o "$dest"
	elif command -v wget >/dev/null 2>&1; then
		wget -qO "$dest" "$url"
	else
		error "Neither 'curl' nor 'wget' is installed. Please install one and rerun."
		exit 1
	fi
}

ask_yes_no() {
	local num="$1"
	shift
	local question="$1"
	shift
	local default="${1:-y}"
	local prompt default_letter answer

	if [[ "$default" == "y" ]]; then
		prompt="Y/n"
		default_letter="y"
	else
		prompt="y/N"
		default_letter="n"
	fi

	if [[ "$INTERACTIVE" -eq 0 ]]; then
		info "Q${num}) ${question} [auto: ${default_letter}]"
		echo "$default_letter"
		return 0
	fi

	while true; do
		printf "Q%s) %s [%s]: " "$num" "$question" "$prompt" >&2
		read -r answer
		answer="${answer:-$default_letter}"
		case "${answer,,}" in
		y | yes)
			echo "y"
			return 0
			;;
		n | no)
			echo "n"
			return 0
			;;
		*) printf "Please answer y or n.\n" >&2 ;;
		esac
	done
}

ask_input() {
	local num="$1"
	shift
	local question="$1"
	shift
	local default="$1"
	shift || true
	local answer

	if [[ "$INTERACTIVE" -eq 0 ]]; then
		info "Q${num}) ${question} [auto: ${default}]"
		echo "$default"
		return 0
	fi

	printf "Q%s) %s [%s]: " "$num" "$question" "$default" >&2
	read -r answer
	echo "${answer:-$default}"
}

ask_omnisharp_mode() {
	local num="$1"
	shift
	local default_mode="$1"
	shift

	if [[ "$INTERACTIVE" -eq 0 ]]; then
		info "Q${num}) OmniSharp / C# editor support [auto: ${default_mode}]"
		echo "$default_mode"
		return 0
	fi

	local default_choice="3"
	case "$default_mode" in
	vscode) default_choice="1" ;;
	server) default_choice="2" ;;
	both) default_choice="3" ;;
	none) default_choice="4" ;;
	esac

	local choice
	while true; do
		cat >&2 <<EOF
Q${num}) OmniSharp / C# editor support:
    1) VS Code C# extension only        (ms-dotnettools.csharp)
    2) OmniSharp server only            (for Neovim/Vim/Emacs)
    3) Both VS Code extension + server  (recommended)
    4) None                             (skip editor tooling)
EOF
		printf "    Enter a number 1–4 [%s]: " "$default_choice" >&2
		read -r choice
		choice="${choice:-$default_choice}"

		case "$choice" in
		1)
			echo "vscode"
			return 0
			;;
		2)
			echo "server"
			return 0
			;;
		3)
			echo "both"
			return 0
			;;
		4)
			echo "none"
			return 0
			;;
		*) printf "    Invalid choice. Please enter 1, 2, 3, or 4.\n" >&2 ;;
		esac
	done
}

DEFAULT_CHANNELS="6.0 8.0 9.0"
SDK_CHANNELS=()
INSTALL_METHOD="pm" # pm | script
RUN_UPDATE="y"
INSTALL_DEPS="y"
INSTALL_GLOBAL_TOOLS="y"
OMNISHARP_MODE="both" # vscode | server | both | none
MODIFY_BASHRC="y"

run_questions() {
	local ans channels_str

	ans=$(ask_yes_no 1 "Continue with .NET SDK (6, 8, 9) + tools installation?" "y")
	[[ "$ans" == "y" ]] || {
		info "Aborting by user request."
		exit 0
	}

	ans=$(ask_yes_no 2 "Detected distro is ${DISTRO} (${PRETTY}). Is this correct?" "y")
	[[ "$ans" == "y" ]] || {
		error "Distro detection not confirmed. Exiting."
		exit 1
	}

	ans=$(ask_yes_no 3 \
		"Install SDKs system-wide using the distro package manager (sudo apt/pacman)? (No = per-user via dotnet-install.sh)" \
		"y")
	INSTALL_METHOD=$([[ "$ans" == "y" ]] && echo "pm" || echo "script")

	channels_str=$(ask_input 4 "Which .NET SDK channels to install (space-separated)?" "$DEFAULT_CHANNELS")
	read -r -a SDK_CHANNELS <<<"$channels_str"

	RUN_UPDATE=$(ask_yes_no 5 "Is it OK to run package database update (apt update / pacman -Sy)?" "y")
	INSTALL_DEPS=$(ask_yes_no 6 "Install base packages (curl, ca-certificates, git) via package manager?" "y")
	INSTALL_GLOBAL_TOOLS=$(ask_yes_no 7 \
		"Install major .NET global tools (ef, format, outdated, aspnet-codegenerator, script, sonarscanner, repl)?" "y")
	OMNISHARP_MODE=$(ask_omnisharp_mode 8 "both")
	MODIFY_BASHRC=$(ask_yes_no 9 \
		"Append PATH setup for dotnet (~/.dotnet and ~/.dotnet/tools) to ~/.bashrc?" "y")

	echo
	info "Configuration summary:"
	echo "  Distro:                   $DISTRO ($PRETTY)"
	echo "  Install method:           $INSTALL_METHOD"
	echo "  SDK channels:             ${SDK_CHANNELS[*]}"
	echo "  Run pkg update:           $RUN_UPDATE"
	echo "  Install base deps:        $INSTALL_DEPS"
	echo "  Install global tools:     $INSTALL_GLOBAL_TOOLS"
	echo "  OmniSharp mode:           $OMNISHARP_MODE"
	echo "  Modify ~/.bashrc:         $MODIFY_BASHRC"
	echo

	ans=$(ask_yes_no 10 "Proceed with installation using these settings?" "y")
	[[ "$ans" == "y" ]] || {
		info "Aborting by user choice."
		exit 0
	}
}

install_deps_ubuntu() {
	local deps=(curl ca-certificates git)
	info "Installing base packages on Ubuntu: ${deps[*]}"
	sudo apt-get install -y "${deps[@]}"
}

install_deps_arch() {
	local deps=(curl ca-certificates git)
	info "Installing base packages on Arch: ${deps[*]}"
	sudo pacman -S --needed --noconfirm "${deps[@]}"
}

install_sdk_with_pm_ubuntu() {
	local need_apt_update=0 tmp_deb url pkgs=() ch

	if [[ ! -f /etc/apt/sources.list.d/microsoft-prod.list ]]; then
		info "Adding Microsoft package repository for .NET..."
		tmp_deb="$(mktemp /tmp/packages-microsoft-prod.XXXXXX.deb)"
		url="https://packages.microsoft.com/config/ubuntu/${VERSION_ID}/packages-microsoft-prod.deb"
		info "Downloading: $url"
		download_file "$url" "$tmp_deb"
		sudo dpkg -i "$tmp_deb"
		rm -f "$tmp_deb"
		need_apt_update=1
	fi

	if [[ "$RUN_UPDATE" == "y" || "$need_apt_update" -eq 1 ]]; then
		info "Running: sudo apt-get update"
		sudo apt-get update
	elif [[ "$need_apt_update" -eq 1 ]]; then
		error "Microsoft .NET apt repo added but 'apt-get update' was disallowed."
		error "Run 'sudo apt-get update' manually and rerun this script."
		exit 1
	fi

	[[ "$INSTALL_DEPS" == "y" ]] && install_deps_ubuntu

	for ch in "${SDK_CHANNELS[@]}"; do
		case "$ch" in
		6.0 | 8.0 | 9.0) pkgs+=("dotnet-sdk-$ch") ;;
		*)
			error "Unsupported .NET channel '$ch' on Ubuntu. Supported: 6.0, 8.0, 9.0."
			exit 1
			;;
		esac
	done

	info "Installing .NET SDK packages via apt: ${pkgs[*]}"
	sudo apt-get install -y "${pkgs[@]}"
}

install_sdk_with_pm_arch() {
	local pkgs=() ch

	[[ "$RUN_UPDATE" == "y" ]] && {
		info "Running: sudo pacman -Sy"
		sudo pacman -Sy
	}
	[[ "$INSTALL_DEPS" == "y" ]] && install_deps_arch

	for ch in "${SDK_CHANNELS[@]}"; do
		case "$ch" in
		6.0) pkgs+=("dotnet-sdk-6.0") ;;
		8.0) pkgs+=("dotnet-sdk-8.0") ;;
		9.0)
			if pacman -Si dotnet-sdk-9.0 >/dev/null 2>&1; then
				pkgs+=("dotnet-sdk-9.0")
			else
				pkgs+=("dotnet-sdk")
			fi
			;;
		*)
			error "Unsupported .NET channel '$ch' on Arch. Supported: 6.0, 8.0, 9.0."
			exit 1
			;;
		esac
	done

	info "Installing .NET SDK packages via pacman: ${pkgs[*]}"
	sudo pacman -S --needed --noconfirm "${pkgs[@]}"
}

install_sdk_with_script() {
	local install_dir="$HOME/.dotnet" script_path ch

	mkdir -p "$install_dir"

	if [[ "$INSTALL_DEPS" == "y" ]]; then
		if [[ "$DISTRO" == "ubuntu" ]]; then
			[[ "$RUN_UPDATE" == "y" ]] && {
				info "Running: sudo apt-get update"
				sudo apt-get update
			}
			install_deps_ubuntu
		else
			[[ "$RUN_UPDATE" == "y" ]] && {
				info "Running: sudo pacman -Sy"
				sudo pacman -Sy
			}
			install_deps_arch
		fi
	fi

	script_path="$install_dir/dotnet-install.sh"
	info "Downloading dotnet-install.sh to $script_path"
	download_file "https://dot.net/v1/dotnet-install.sh" "$script_path"
	chmod +x "$script_path"

	for ch in "${SDK_CHANNELS[@]}"; do
		info "Installing .NET SDK channel $ch via dotnet-install.sh (quality=ga)..."
		"$script_path" --channel "$ch" --install-dir "$install_dir" --quality "ga"
	done

	export DOTNET_ROOT="$install_dir"
	export PATH="$DOTNET_ROOT:$DOTNET_ROOT/tools:$PATH"
}

verify_sdks() {
	info "Verifying installed .NET SDKs..."

	if ! command -v dotnet >/dev/null 2>&1; then
		error "'dotnet' not found on PATH after installation."
		exit 1
	fi

	local list ch pattern nine
	list="$(dotnet --list-sdks || true)"
	[[ -n "$list" ]] || {
		error "'dotnet --list-sdks' returned no SDKs."
		exit 1
	}

	for ch in "${SDK_CHANNELS[@]}"; do
		pattern="^${ch//./\\.}\\."
		if ! printf '%s\n' "$list" | grep -qE "$pattern"; then
			error ".NET SDK $ch does not appear in 'dotnet --list-sdks'."
			printf '%s\n' "$list"
			exit 1
		fi
	done

	for ch in "${SDK_CHANNELS[@]}"; do
		if [[ "$ch" == "9.0" ]]; then
			nine="$(printf '%s\n' "$list" | grep -E '^9\.0\.' || true)"
			[[ -n "$nine" ]] || {
				error "Requested .NET SDK 9.0 but it was not installed."
				exit 1
			}
			if printf '%s\n' "$nine" | grep -qiE 'preview|rc'; then
				error ".NET 9 SDK appears to be pre-release (preview/rc); stable only requested."
				printf '%s\n' "$nine"
				exit 1
			fi
		fi
	done

	info "Installed SDKs:"
	printf '%s\n' "$list"
}

install_global_tools() {
	local tools=(
		dotnet-ef
		dotnet-format
		dotnet-outdated-tool
		dotnet-aspnet-codegenerator
		dotnet-script
		dotnet-sonarscanner
		dotnet-repl
	)
	local t

	export PATH="$HOME/.dotnet/tools:$PATH"

	info "Installing/updating .NET global tools: ${tools[*]}"
	for t in "${tools[@]}"; do
		info "Handling tool: $t"
		if dotnet tool update --global "$t" >/dev/null 2>&1; then
			info "Updated $t"
			continue
		fi
		dotnet tool uninstall --global "$t" >/dev/null 2>&1 || true
		if dotnet tool install --global "$t" --verbosity minimal; then
			info "Installed $t"
		else
			warn "Failed to install/update tool '$t'."
			if [[ "$t" == "dotnet-ef" ]]; then
				warn "If dotnet-ef keeps failing, try clearing:"
				warn "  rm -rf \"\$HOME/.nuget/packages/.tools/dotnet-ef\""
				warn "  rm -rf \"\$HOME/.nuget/packages/dotnet-ef\""
			fi
		fi
	done

	info "Global tools installed (or attempted):"
	dotnet tool list --global || true
}

install_omnisharp() {
	case "$OMNISHARP_MODE" in
	vscode)
		if command -v code >/dev/null 2>&1; then
			info "Installing VS Code C# extension (ms-dotnettools.csharp)..."
			code --install-extension ms-dotnettools.csharp --force ||
				warn "Failed to install VS Code C# extension."
		else
			warn "VS Code ('code') not found on PATH; skipping VS Code C# extension."
		fi
		;;
	server)
		if [[ "$DISTRO" == "arch" ]]; then
			if pacman -Si omnisharp-roslyn >/dev/null 2>&1; then
				info "Installing OmniSharp Roslyn server via pacman..."
				sudo pacman -S --needed --noconfirm omnisharp-roslyn
			else
				warn "'omnisharp-roslyn' package not found in Arch repos; use AUR or editor-managed binaries."
			fi
		else
			warn "No official 'omnisharp-roslyn' package for Ubuntu; usually editor plugin downloads it."
		fi
		;;
	both)
		local saved="$OMNISHARP_MODE"
		OMNISHARP_MODE="vscode"
		install_omnisharp
		OMNISHARP_MODE="server"
		install_omnisharp
		OMNISHARP_MODE="$saved"
		;;
	none)
		info "Skipping OmniSharp / C# editor tooling."
		;;
	esac
}

modify_bashrc() {
	local bashrc="$HOME/.bashrc"
	local marker="# >>> dotnet multi-setup (auto-added)"

	if [[ -f "$bashrc" ]] && grep -q "$marker" "$bashrc" 2>/dev/null; then
		info "~/.bashrc already contains dotnet PATH block; skipping."
		return
	fi

	info "Appending dotnet PATH block to $bashrc"
	{
		echo ""
		echo "$marker"
		echo 'if [ -d "$HOME/.dotnet" ]; then'
		echo '  export DOTNET_ROOT="$HOME/.dotnet"'
		echo '  export PATH="$DOTNET_ROOT:$DOTNET_ROOT/tools:$PATH"'
		echo 'fi'
		echo "# <<< dotnet multi-setup (auto-added)"
	} >>"$bashrc"
}

main() {
	detect_distro
	run_questions

	info "Starting .NET installation..."

	if [[ "$INSTALL_METHOD" == "pm" ]]; then
		if [[ "$DISTRO" == "ubuntu" ]]; then
			install_sdk_with_pm_ubuntu
		else
			install_sdk_with_pm_arch
		fi
	else
		install_sdk_with_script
	fi

	verify_sdks

	[[ "$INSTALL_GLOBAL_TOOLS" == "y" ]] && install_global_tools
	install_omnisharp
	[[ "$MODIFY_BASHRC" == "y" ]] && modify_bashrc

	echo
	info "DONE."
	echo "You may need to open a new terminal or run:"
	echo "  source ~/.bashrc"
	echo
	echo "Current SDKs:"
	dotnet --list-sdks || true
}

if [[ -n "$LOG_FILE" ]]; then
	mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null || true
	main 2>&1 | tee "$LOG_FILE"
	exit "${PIPESTATUS[0]}"
else
	main
fi
