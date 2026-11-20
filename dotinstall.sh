#!/usr/bin/env bash
# Run with: bash dotinstall.sh (not sudo).
#
# Installs and configures:
# 1. Dotfiles repository settings.
# 2. Homebrew and its shell environment.
# 3. CLI tools from .config/packages/Brewfile and their man pages.
#    Passwordless sudo and Homebrew Bash as the user's login shell.
# 4. Rust toolchain via rustup.
# 5. NVM and Node.js LTS.
# 6. Tools from .config/packages/npm.txt and pipx.txt.
# 7. Neovim plugins and locked language tools.
# 8. TPM and the tmux plugins listed in .tmux.conf.
# 9. Synth-Shell prompt.
# 10. GitHub CLI login.
#
# Dependencies:
# - Bash
# - Git
# - curl
# - sudo
# - visudo
# - chsh
# - Dotfiles already checked out into $HOME
#
# Details:
# - Supports Linux and macOS; Homebrew may request sudo for prerequisites.
# - Uses the shell profiles and prompt configuration supplied by the dotfiles.
# - Open a new Bash session after installation to load the environment.

# set -eo pipefail

if [[ ${EUID} -eq 0 ]]; then
    echo 'Run this script as your normal user, not with sudo.' >&2
    exit 1
fi

system=$(uname -s)
case "$system" in
    Linux|Darwin) ;;
    *) echo 'This installer supports macOS and Linux.' >&2; exit 1 ;;
esac

for tool in git curl; do
    command -v "$tool" >/dev/null || {
        echo "Install $tool with your OS package manager first." >&2
        exit 1
    }
done

workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

# 1. Dotfiles
dotrepo="$HOME/.dotfiles.git"
git --git-dir="$dotrepo" config --local status.showUntrackedFiles no
git --git-dir="$dotrepo" config --local core.excludesFile "$HOME/.dotfiles.gitignore"

# 2. Homebrew
for brew_bin in "$HOME/.linuxbrew/bin/brew" /opt/homebrew/bin/brew \
    /home/linuxbrew/.linuxbrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$brew_bin" ]]; then
        eval "$("$brew_bin" shellenv)"
        break
    fi
done

if ! command -v brew >/dev/null; then
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh \
        -o "$workdir/homebrew-install.sh"
    bash "$workdir/homebrew-install.sh"
    case "$system" in
        Linux) eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" ;;
        Darwin) eval "$(/opt/homebrew/bin/brew shellenv)" ;;
    esac
fi

# 3. CLI tools
brew bundle install --file="$HOME/.config/packages/Brewfile" || exit 1

# Configure the account, using the stable Homebrew symlink across upgrades.
brew_shell="$(brew --prefix)/bin/bash" || exit 1
if [[ ! -x "$brew_shell" ]]; then
    echo "Homebrew Bash is missing: $brew_shell" >&2
    exit 1
fi
current_user=$(id -un) || exit 1
current_uid=$(id -u) || exit 1
printf '#%s ALL=(ALL:ALL) NOPASSWD: ALL\n' "$current_uid" > "$workdir/sudoers" || exit 1
sudo visudo -cf "$workdir/sudoers" || exit 1
sudo mkdir -p /etc/sudoers.d || exit 1
sudo install -o 0 -g 0 -m 0440 "$workdir/sudoers" \
    "/etc/sudoers.d/99-dotinstall-$current_uid" || exit 1
sudo visudo -c || exit 1
# Check without cached credentials, including whether sudoers.d is enabled.
sudo -n -k true || {
    echo 'Passwordless sudo is not active; check /etc/sudoers includes /etc/sudoers.d.' >&2
    exit 1
}
if ! grep -Fxq "$brew_shell" /etc/shells; then
    printf '\n%s\n' "$brew_shell" | sudo tee -a /etc/shells >/dev/null || exit 1
fi
sudo chsh -s "$brew_shell" "$current_user" || exit 1

# shellcheck source=/dev/null
source "$HOME/.local/bin/env"

# 4. Rust
if [[ ! -x "$HOME/.cargo/bin/rustup" ]]; then
    curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs \
        -o "$workdir/rustup-install.sh"
    sh "$workdir/rustup-install.sh" -y --no-modify-path
fi

# shellcheck source=/dev/null
source "$HOME/.cargo/env"

# 5. NVM and Node.js
export NVM_DIR="$HOME/.config/nvm"

if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
    mkdir -p "$NVM_DIR"
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.41.0/install.sh \
        -o "$workdir/nvm-install.sh"
    PROFILE=/dev/null bash "$workdir/nvm-install.sh"
fi

# shellcheck source=/dev/null
source "$NVM_DIR/nvm.sh"
nvm install --lts

# 6. npm and pipx tools
for manager in npm pipx; do
    list="$HOME/.config/packages/$manager.txt"
    [[ -f "$list" ]] || continue
    packages=()
    while IFS= read -r line || [[ -n "$line" ]]; do
        line=${line%%#*}
        args=()
        read -r -a args <<< "$line"
        [[ ${#args[@]} -gt 0 ]] || continue
        case "$manager" in
            npm) packages+=("${args[@]}") ;;
            pipx) pipx install "${args[@]}" ;;
        esac
    done < "$list"
    if [[ "$manager" == npm && ${#packages[@]} -gt 0 ]]; then
        npm install --global "${packages[@]}"
    fi
done

# 7. Neovim
nvim --headless -c "lua dofile(vim.fn.stdpath('config') .. '/bootstrap.lua')"

# 8. TPM and tmux plugins
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    git clone --depth 1 https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm"
fi

TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins/" \
    "$HOME/.tmux/plugins/tpm/bin/install_plugins"

# 9. Synth-Shell prompt
if [[ ! -f "$HOME/.config/synth-shell/synth-shell-prompt.sh" ]]; then
    git clone --depth 1 --recurse-submodules \
        https://github.com/andresgongora/synth-shell-prompt.git "$workdir/synth-shell"
    # Build without adding another shell hook or copying default configuration.
    bash -c 'source "$1"; assembleScript "$2" "$3"; test -s "$3"' bash \
        "$workdir/synth-shell/bash-tools/bash-tools/assemble_script.sh" \
        "$workdir/synth-shell/synth-shell-prompt/synth-shell-prompt.sh" \
        "$workdir/synth-shell-prompt.sh"
    bash -n "$workdir/synth-shell-prompt.sh"
    mkdir -p "$HOME/.config/synth-shell"
    install -m 644 "$workdir/synth-shell-prompt.sh" \
        "$HOME/.config/synth-shell/synth-shell-prompt.sh"
fi

# 10. GitHub CLI
gh auth status --hostname github.com >/dev/null 2>&1 || \
    gh auth login --hostname github.com --web --git-protocol ssh \
        --skip-ssh-key --clipboard || exit 1

printf '\nInstallation complete. Log out and back in to use Homebrew Bash.\n'
