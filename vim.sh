#!/bin/bash

timestamp=$(date +"%Y%m%d_%s")

# user's local paths
localVimrc=~/.vimrc
localVimdir=~/.vim
localHelperdir=~/vim-helpers

# paths in this repo
repoVimrc=.vimrc
repoVimdir=.vim
repoPlugindir=vim-plugins
repoHelperdir=vim-helpers

curvimrc=$(ls -la ~ | grep '\.vimrc$' | wc -l)
curvimdir=$(ls -la ~ | grep '\.vim$' | wc -l)
curhelperdir=$(ls -l ~ | grep 'vim-helpers$' | wc -l)

# creates a vim version number
vimversion=$(vim --version | head -1 | awk '
{
    match($0, /[[:digit:]]+\.[[:digit:]]+(\.[[:digit:]]+)?/);
    split(substr($0, RSTART, RLENGTH), a, /\./);
    version=0;
    if (1 in a) version += a[1] * 100;
    if (2 in a) version += a[2];
    if (3 in a) 
        version = version a[3];
    else
        version = version "000";
    print version;
}')

# if .vimrc, .vim, or vim-helpers already exist, backup first
if [ $curvimrc == 1 ];
then
    echo -e "moving $localVimrc to ${localVimrc}_$timestamp"
    mv "$localVimrc" "${localVimrc}_$timestamp"
fi

if [ $curvimdir == 1 ];
then
    echo -e "moving $localVimdir to ${localVimdir}_$timestamp"
    mv -f "$localVimdir" "${localVimdir}_$timestamp"
fi

if [ $curhelperdir == 1 ];
then
    echo -e "moving $localHelperdir to ${localHelperdir}_$timestamp"
    mv -f "$localHelperdir" "${localHelperdir}_$timestamp"
fi

# copy .vimrc and the skeleton .vim directory (only contains pathogen plugin)
echo -e "copying vim files to " ~
cp "$repoVimrc" "$localVimrc"
cp -r "$repoVimdir" "$localVimdir"
cp -r "$repoHelperdir" "$localHelperdir"

# create the bundle directory if it doesn't exist
if [ ! -d "${localVimdir}/bundle" ];
then
    mkdir "${localVimdir}/bundle"
fi


# copy all plugins to .vim/bundle so that they can be picked up by pathogen
plugins=$(find "$repoPlugindir" -maxdepth 1 -type d -not -name "$repoPlugindir")

for plugin in $plugins
do
    # see tagbar documentation.  vim version < 7.0.167 needs a different version
    # of tagbar (2.2)
    if [[ "$plugin" =~ tagbar$ ]];
    then
        if [ "$vimversion" -le 700167 ];
        then
            cp -r "$plugin/majutsushi-tagbar-5dfb7cc" "${localVimdir}/bundle/tagbar"
        else
            cp -r "$plugin/majutsushi-tagbar-dec1f84" "${localVimdir}/bundle/tagbar"
        fi
    else
        cp -r "$plugin" "${localVimdir}/bundle"
    fi
done

# install phpctags
cd "$localHelperdir/vim-plugin-tagbar-phpctags/" && make
