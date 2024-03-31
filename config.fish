## Set values
# Hide welcome message
set -x EDITOR "nvim"

set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"
set -x MANROFFOPT "-c"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -x CHROME_EXECUTABLE "/usr/bin/google-chrome-stable"

## Export variable need for qt-theme
if type "qtile" >> /dev/null 2>&1
   set -x QT_QPA_PLATFORMTHEME "qt5ct"
end

# Set settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low


## Environment setup
# Apply .profile: use this to put fish compatible .profile stuff in
if test -f ~/.fish_profile
  source ~/.fish_profile
end

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

# Add depot_tools to PATH
if test -d ~/Applications/depot_tools
    if not contains -- ~/Applications/depot_tools $PATH
        set -p PATH ~/Applications/depot_tools
    end
end

# Add ~/.local/flutter/bin/ to PATH
if test -d ~/.local/flutter/bin
    if not contains -- ~/.local/flutter/bin $PATH
        set -p PATH ~/.local/flutter/bin
    end
end

# Add ~/.local/cmdline-tools/bin to PATH
if test -d ~/.local/cmdline-tools/bin 
    if not contains -- ~/.local/cmdline-tools/bin $PATH
        set -p PATH ~/.local/cmdline-tools/bin 
    end
end


## Starship prompt
if status --is-interactive
   source ("/usr/bin/starship" init fish --print-full-init | psub)
end


## Advanced command-not-found hook
source /usr/share/doc/find-the-command/ftc.fish


## Functions
# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

fish_vi_key_bindings

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

# Copy DIR1 DIR2
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
	set from (echo $argv[1] | trim-right /)
	set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

## Useful aliases
# Replace ls with exa
alias ls='exa --color=always --group-directories-first --icons' # preferred listing
alias l='ls'
alias sl='ls'
alias lh='ls -dl .*'
alias la='ls -a'
alias al='la'
alias ll='la -l'
alias lll='la -lh'
alias lt='ls -aT' # tree listing
alias l.='ls -ald .*' # show only dotfiles
alias fl='lf'

alias ip='ip -color'

# Confirm file operations
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'

# Disk / Memory usage
alias df='df -h'
alias du='du -h'
alias free='free -h'

# Duration of media files
alias dur='exiftool -T -Duration -FileName "$1" 2>/dev/null'

# Replace some more things with better alternatives
alias cat='bat --style header --style snip --style changes --style header'
[ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'

# Common use
alias grubup="sudo update-grub"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -xvf '
alias wget='wget -c '
alias rmpkg="sudo pacman -Rdd"
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias upd='/usr/bin/garuda-update'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='grep -F --color=auto'
alias egrep='grep -E --color=auto'
alias hw='hwinfo --short'                          # Hardware Info
alias big="expac -H M '%m\t%n' | sort -h | nl"     # Sort installed packages according to size in MB
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages

# Get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Help people new to Arch
alias apt='man pacman'
alias apt-get='man pacman'
alias please='sudo'
alias tb='nc termbin.com 9999'

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# Youtubedl
abbr -a yt  'yt-dlp -o "%(title)s.%(ext)s" -f b --embed-chapters'
abbr -a yta 'yt-dlp -o "%(autonumber)s-%(title)s.%(ext)s" -f b --embed-chapters'
abbr -a ytb 'yt-dlp -o "%(title)s.%(ext)s" -f bestvideo+bestaudio --embed-chapters'
abbr -a ytm 'yt-dlp -o "%(autonumber)s %(title)s.%(ext)s" -f bestaudio --embed-chapters'

function fp
  set -l project (fd --type d --hidden . ~/Projects/ | fzf)
  if test -z $project
    cd .
  else
    cd $project
  end
end

function np
  set -l project (fd --type d --hidden . ~/Projects/ | fzf)
  mkdir -p $project/$argv[1]
  cd $project/$argv[1]
end

# Run fastfetch if session is interactive
# if status --is-interactive && type -q fastfetch
#   fastfetch --load-config dr460nized
# end
