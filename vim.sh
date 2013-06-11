#!/bin/bash

timestamp=$(date +"%Y%m%d_%s")

vimrc=~/.vimrc
vimdir=~/.vim

curvimrc=$(ls -la ~ | grep '\.vimrc$' | wc -l)
curvimdir=$(ls -la ~ | grep '\.vim$' | wc -l)

plugindir=vim-plugins

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

# if .vimrc and .vim already exist, backup first
if [ $curvimrc == 1 ];
then
    echo -e "moving $vimrc to ${vimrc}_$timestamp"
    mv "$vimrc" "${vimrc}_$timestamp"
fi

if [ $curvimdir == 1 ];
then
    echo -e "moving $vimdir to ${vimdir}_$timestamp"
    mv -f "$vimdir" "${vimdir}_$timestamp"
fi

# copy .vimrc and the skeleton .vim directory (only contains pathogen plugin)
echo -e "copying vim files to " ~
cp ".vimrc" "$vimrc"
cp -r ".vim" "$vimdir"

# create the bundle directory if it doesn't exist
if [ ! -d "${vimdir}/bundle" ];
then
    mkdir "${vimdir}/bundle"
fi


# copy all plugins to .vim/bundle so that they can be picked up by pathogen
plugins=$(find "$plugindir" -maxdepth 1 -type d -not -name "$plugindir")

for plugin in $plugins
do
    # see tagbar documentation.  vim version < 7.0.167 needs a different version
    # of tagbar (2.2)
    if [[ "$plugin" =~ "tagbar" ]];
    then
        if [ "$vimversion" -le 700167 ];
        then
            cp -r "$plugin/majutsushi-tagbar-5dfb7cc" "${vimdir}/bundle/tagbar"
        else
            cp -r "$plugin/majutsushi-tagbar-dec1f84" "${vimdir}/bundle/tagbar"
        fi
    else
        cp -r "$plugin" "${vimdir}/bundle"
    fi
done
