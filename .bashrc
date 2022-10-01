cd ~/Munka/fcomply-new-adjuvo
force_color_prompt=yes
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
ssh-add -l

alias dcr='docker compose run --rm'
alias config='/usr/bin/git --git-dir=/home/greg/.cfg/ --work-tree=/home/greg'
