# Dotfiles

Configuration multi-profil (`pro` / `perso`) gérée avec [Chezmoi](https://www.chezmoi.io/) pour déployer rapidement un poste de travail Linux Ubuntu propre, reproductible et sans aucun secret versionné.

## 1. Publier ce dépôt sur GitHub (première fois)

1. Crée un dépôt **privé** vide nommé `dotfiles` sur GitHub (`SagazanBaptiste/dotfiles`).
2. Pousse le commit initial déjà préparé :

```sh
chezmoi git -- push -u origin main
```

## 2. Installer sur un nouveau PC Ubuntu (1 commande)

Après avoir généré une clé SSH dédiée à ce poste et l'avoir ajoutée à GitHub :

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:SagazanBaptiste/dotfiles.git
```

Chezmoi te demandera interactivement :
- `profile` : `pro` ou `perso`
- `git_name` / `git_email` / `git_signingkey` (optionnel)
- `install_packages` : `true` pour exécuter les scripts `run_once_` (paquets `apt`, `mise`, `uv`, `rustup`, polices, apps desktop, extensions VS Code)

## 3. Différences entre les profils `pro` et `perso`

| Élément | `pro` | `perso` |
|---|---|---|
| **Shell / Terminal / Éditeurs** | `zsh`, `oh-my-zsh`, `starship`, `ghostty`, `nvim` (minimal), `lazygit`, VS Code | Identique |
| **CLIs socles (`mise` + `uv` + `rtk`)** | `node`, `go`, `uv`, `nvim`, `starship`, `zoxide`, `fzf`, `lazygit`, `delta`, `yq`, `duckdb`, `basedpyright`, `debugpy`, `ty` | Identique |
| **CLIs Cloud / Infra** | `kubectl`, `k9s`, `helm`, `helmfile`, `kind`, `terraform`, `task`, `maven`, `hl`, `mc` | Non installés |
| **VPN Mullvad (Gluetun)** | Ignoré via `.chezmoiignore` | `~/.start_gluetun.sh` + `~/dockerfiles/wireguard/` |
| **Apps & IA** | `claude`, `agy`, `ghostty`, `code`, `vlc`, `obs`, `bitwarden`, `chrome`, `mcp-tools` | Identique |

## 4. Checklist post-install hors Git

Ces éléments ne sont **jamais** stockés dans Git et doivent être configurés localement après l'installation :

1. **Identité SSH & GPG :** générer une paire SSH neuve par machine (`ssh-keygen -t ed25519`) et, si besoin, une nouvelle clé GPG pour signer les commits (`git_signingkey`).
2. **Bitwarden :** se connecter pour récupérer tokens et accès.
3. **Clients IA :** authentifier `claude` (`claude` CLI / Claude Desktop), Antigravity (`agy` / Antigravity Desktop), et copier les éventuels hooks/plugins si besoin.
4. **Profil `perso` — VPN Mullvad :** copier `~/dockerfiles/wireguard/.env.example` vers `~/dockerfiles/wireguard/.env` et renseigner `WIREGUARD_PRIVATE_KEY` et `WIREGUARD_ADDRESSES`.
5. **MCP tools (`~/tools`) :** une fois `~/tools` cloné, créer `~/.config/tools-daemon/config.yml` (hors Git) et recréer les symlinks souhaités depuis `~/tools/skills/`.
6. **Apps installées manuellement :** Claude Desktop, Antigravity Desktop et tweaks GNOME (raccourcis, mode sombre, dispositions clavier, souris).
