
# Install packages
sudo pacman -Syyu 
sudo pacman -S pyenv git 

# Setup OMYZSH
echo "Setting up OH MY ZSH``"
git clone https://github.com/ohmyzsh/ohmyzsh ~/.oh-mh-zsh
sudo pacman -S zsh-autosuggestions zsh-syntax-highlighting

echo "Chaning terminal"
chsh -s $(which zsh)


# Install other apps
echo "Installing APPS"
sudo pacman -S hypr rofi-wayland neovide neovim lazygit tmux newsboat zen-browser-bin screen nwg-look waybar hyprlock, sway-contrib cliphist brightnessctl

# Install fonts
echo "Installing fonts"
sudo pacman -S ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-0xproto-nerd

# Install gcloud
# TODO

echo "Done"
