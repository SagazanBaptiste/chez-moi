# Antisèche Neovim

Seulement ce que j'ai réellement appris et pratiqué. Une ligne = un réflexe.
Repère AZERTY : ⇧ = demande Maj, ⌥G = demande AltGr.

## Se déplacer dans une ligne

| Touche | Effet | Note |
|---|---|---|
| `à` | début de ligne (colonne 0) | mapping perso, remplace `0` (⇧ en AZERTY) |
| `_` | premier caractère non blanc | natif, sans Maj ; `^` fait pareil mais touche morte |
| `$` | fin de ligne | |
| `w` / `b` | mot suivant / précédent | s'arrête sur chaque `.` et `=` |
| `W` / `B` | MOT suivant / précédent | ne s'arrête qu'aux espaces |
| `f=` | saute sur le prochain `=` | `;` répète, `,` dans l'autre sens |

## Se déplacer entre les lignes

| Touche | Effet |
|---|---|
| `3G` | ligne 3 |
| `5j` / `5k` | 5 lignes plus bas / haut (lire le nombre dans `relativenumber`) |

## Modifier

| Touche | Effet |
|---|---|
| `ciw` | remplace le mot sous le curseur |
| `.` | rejoue la dernière modification (⇧ en AZERTY) |
| `u` | annule |
| `yy` | copie (yank) la ligne |
| `p` / `P` | colle après / avant ; `3p` colle 3 fois |
| `"0p` | colle le dernier **yank**, même après un `dd` |

## Objets texte : opérateur + `i`/`a` + objet

`i` = intérieur (*inner*), `a` = avec les délimiteurs (*around*). Le curseur peut être n'importe où dedans.

| Touche | Effet | Note |
|---|---|---|
| `ciB` | vide l'intérieur de `{…}` et passe en insertion | `B` évite AltGr ; `ci{` marche aussi |
| `cib` | idem pour `(…)` | `ci(` marche aussi |
| `ci"` / `ci'` | intérieur des guillemets | cherche aussi plus loin sur la ligne |
| `ciw` | le mot | |
| `daB` / `yi"`… | même grammaire avec `d` (supprimer) ou `y` (copier) | |

## Entourer (natif, sans plugin)

| Touche | Effet |
|---|---|
| `ciw{` `Ctrl-r "` `}` `Échap` | entoure le mot de `{}` |
| `vi'` puis `c(` `Ctrl-r "` `)` | entoure une sélection |
| `Ctrl-r "` (insertion ou `:`) | insère le contenu du registre `"` |

Candidat plugin si fréquent : `mini.surround` (voir « À revisiter »).

## Plusieurs lignes à la fois (« multicurseur »)

| Commande | Effet |
|---|---|
| `Ctrl-v` `5j` `I`texte`Échap` | insère « texte » en début de 6 lignes |
| `:3,8s/^/vim.opt./` | même chose en commande Ex ; `^` = début de ligne |
| `:3,7s/on$/true/` | remplace `on` en fin de ligne ; `$` = fin de ligne |

## Comprendre / vérifier

| Commande | Effet |
|---|---|
| `Espace ?` | ouvre cette antisèche (mapping perso) |
| `:help 'number'` | aide d'une option (avec les apostrophes) |
| `:verbose set number?` | valeur de l'option et qui l'a réglée |
| `:source %` | recharge le fichier courant (la config) |
| `:lua print(x)` | évalue du Lua |
| `:echo @"` | contenu du registre `"` (dernier texte supprimé ou copié) |
| `NVIM_APPNAME=nvim.bak nvim` | lance l'ancienne config (filet de sécurité) |

## Lua pour un Pythoniste

- Variable inconnue → `nil`, **pas d'erreur** (Python : `NameError`).
- Seuls `nil` et `false` sont faux ; `0` et `""` sont **vrais**.
- Sans `local`, une variable est **globale à tout Neovim** → toujours `local`.
- Une option se règle via `vim.opt.nom = valeur`, une variable globale de Vim via `vim.g.nom`.

| Python | Lua |
|---|---|
| `[1, 2]` / `{"k": 1}` | `{ 1, 2 }` / `{ k = 1 }` (une seule structure : la table) |
| `if x:` … | `if x then … end` |
| `elif` / `else` | `elseif` / `else` |
| `!=` | `~=` |
| `and` `or` `not` | pareil |
| `None` | `nil` |
| `"a" + "b"` | `"a" .. "b"` |
| `len(x)` | `#x` |
| `def f(a):` … | `local function f(a) … end` |
| `lambda: …` | `function() … end` (plusieurs instructions possibles, `return` explicite) |
| `if not s:` (chaîne vide) | `if s == '' then` (`not ''` est **faux** en Lua) |
| `f` (référence) / `f()` (appel) | pareil ; une instruction seule doit être un appel : `f()` |
| `# commentaire` | `-- commentaire` |

Aide : `:help lua-guide` (Lua dans Neovim), `:help lua-concepts`.

## À revisiter

Décisions reportées : on y revient quand le besoin se fait sentir.

- [ ] **`mini.surround`** : entourer / changer / supprimer des délimiteurs. Compteur de fois où ça m'a manqué : 
- [ ] **Remaps AZERTY** : `.` (⇧), `@` (⌥G, mais `Q` rejoue la dernière macro), `Alt-h`/`Alt-l` → `[`/`]` (prévu dans `~/.config/keybindings.md`, jamais implémenté).
- [ ] **`clipboard = 'unnamedplus'`** : d'abord vivre avec `"+y` / `"+p`, puis décider.
- [ ] **`rust-analyzer`** : `rustup component add rust-analyzer` avant l'étape LSP.
