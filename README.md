# vimrc
This is how I try to work.
Lots' of python and bash work, al maintained in git so fugitive is a good tool to add in vim.
Next to that, there are quite some config files that are not in git. For them I want an auto backup, with a timestamp in my ~/vup/
The status line show git status, same for the gutter.

Autopairs is a nice speed-up.

Oh, and I almost forgot about the auto update of the .tags file. I like it.

To install this:
first clone to a convenient location
cd your_cloned_location
cp -p .vimrc ~/
cp -rp .vim ~/

you can also try to use in in the cloned location:
    vim --cmd 'let &rtp = "$PWD/.vim"' -u .vimrc  .vimrc

so, if you want to install in the cloned location, first edit the 
call plug#begin('~/.vim/plugged')
so that it points to the correct .vim/

Open vim as listed above and issue 
:PlugInstall
this installs the plugin into the location that is specified in the .vimrc and the default is
~/.vim/plugged

For ":PlugInstall" to work, the autoload/vim.plug is needed.

When all your paths are defaults (~/.vimrc and ~/.vim/) no changes are needed at all
happy vimming!
