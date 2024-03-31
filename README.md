# Fish Shell Configuration

This repository contains the Fish shell configuration and related scripts for José Henrique Tenório Araújo Cavalcante.

## Installation

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/rikcav/fish.git
   ```

2. Copy or symlink the `config.fish` file to your Fish configuration directory (`~/.config/fish/`):

   ```bash
   cp config.fish ~/.config/fish/
   ```

3. Reload the Fish configuration:

   ```fish
   source ~/.config/fish/config.fish
   ```

## Custom Aliases

- `rm`: Aliased to `rm -Iv` for interactive and verbose file deletion.
- `fp`: Quickly search for a project in `~/Projects`.
- `np`: Create a new directory inside a project directory inside `~/Projects` using `fzf`.

## Usage

Feel free to modify the `config.fish` file and add your custom aliases or functions.
