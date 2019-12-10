# dotfiles

Common configuration files across my machines.

These files apply to several machines:

- Personal Laptop (OSX)
- Work Laptop (OSX)
- Work Desktop (Nixos)

Dotfiles and most program installations are managed by the [Nix package manager](https://nixos.org/nix/). Brew cask is used for OS X GUI programs.

## Installation

1. _(NixOS only)_ Import `nixos/configuration.nix` into `/etc/nixos/configuration.nix` and run `nixos-rebuild switch`.
2. _(OSX only)_ Install the [Nix package manager](https://nixos.org/nix/).
3. Install [Home manager](https://github.com/rycee/home-manager).
4. Clone the secrets repo at `$HOME/private_secrets`. _Obviously, if you're not me, don't do this._
5. Run `home-manager switch`.

## OS-Specific Notes

### Nixos

On NixOS (my main computer's OS), this manages all system configuration.

Notably, I've set up an HTTP ingress on my local network to allow my phone and VR headset to communicate with my main computer. This configuration can be found in `nixos/services/nginx.nix`.

### OS X

On OS X, this installs several helpful developer tools. I still install most GUI programs with `brew cask` as the Darwin support for Nix is pretty limited.

#### Nix installation instructions on Catalina

Instructions here: https://github.com/NixOS/nix/issues/2925#issuecomment-540051636

So I've made my nix installation work with this simple procedure:

```
sudo mkdir /System/Volumes/Data/opt/nix
sudo chown {your_user} /System/Volumes/Data/opt/nix
# Be careful as the space needs to be a tab, otherwise changes won't be picked up from synthetic.conf
sudo sh -c "echo 'nix      System/Volumes/Data/opt/nix' >> /System/Volumes/Data/private/etc/synthetic.conf"
```

Reboot system at this point.

```
export NIX_IGNORE_SYMLINK_STORE=1
curl https://nixos.org/nix/install | sh
```

This worked for me too, but I just want to add that I had to add the line export NIX_IGNORE_SYMLINK_STORE=1 to my shell profile so that I would be able to use it consistently. Otherwise I was getting 'no symlink' messages.

## License

MIT
