# ubuntu-config

The purpose of this repository is to provide the convenience of being able to `git pull` my basic Ubuntu preferences when setting up a new work environment.

This project was inspired by [an Atlassian tutorial on storing dotfiles](https://www.atlassian.com/git/tutorials/dotfiles). Below you will find a transcription of the original tutorial.

---

_The technique consists in storing a Git bare repository in a "side" folder ($HOME/.cfg) using a specially crafted alias ("config") so that commands are run against that repository and not the usual .git local folder, which would interfere with any other Git repositories around._

_No extra tooling, no symlinks, files are tracked on a version control system, you can use different branches for different computers, you can replicate you configuration easily on new installation._

## Starting from scratch

This repository was set up as follows:

```
git init --bare $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc
```

- The first line creates a folder `~/.cfg` which is a Git bare repository that will track our files.
- Then we create an alias `config` which we will use instead of the regular `git` when we want to interact with our configuration repository.
- We set a flag - local to the repository - to hide files we are not explicitly tracking yet. This is so that when you type `config status` and other commands later, files you are not interested in tracking will not show up as `untracked`.
- Also you can add the alias definition by hand to your `.bashrc` or use the the fourth line provided for convenience.

After you've executed the setup any file within the `$HOME` folder can be versioned with normal commands, replacing `git` with your newly created `config` alias, like:

```
config status
config add .bashrc
config commit -m "add bashrc"
config push
```

## Deployment

If you want to set up the repository on a new machine, follow the steps below.

### Prerequisites

Prior to the installation make sure you have committed the alias to your `.bashrc`, and that your source repository ignores the folder where you'll clone it, so that you don't create weird recursion problems.

```
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
echo ".cfg" >> .gitignore
```

### Installing

- Clone your dotfiles into a bare repository in a "dot" folder of your `$HOME`.
- Define the alias in the current shell scope.
- Checkout the actual content from the bare repository to your `$HOME`.
- Set the flag `showUntrackedFiles` to `no` on this specific (local) repository.

```
git clone --bare <git-repo-url> $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config checkout
config config --local status.showUntrackedFiles no
```
### Solving git conflicts

`git checkout` might fail with a message like: _"The following untracked working tree files would be overwritten by checkout [...]"_

This is because your `$HOME` folder might already have some stock configuration files which would be overwritten by Git. The solution is simple: back up the files if you care about them, remove them if you don't care. I provide you with a possible rough shortcut to move all the offending files automatically to a backup folder. Remember to re-run `checkout`!

```
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}
config checkout
```

You're done! From now on you can type `config` commands to add and update your dotfiles.

## License

MIT License

Copyright (c) 2023 Pál Gergő

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Acknowledgments

- Thanks to the team at [Atlassian](https://www.atlassian.com) for the superb tutorial!
- Thanks to [StreakyCobra](https://news.ycombinator.com/item?id=11071754) for the original idea!
