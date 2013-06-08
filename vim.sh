#!/bin/bash

timestamp=$(date +"%Y%m%d_%s")

vimrc=~/.vimrc
vimdir=~/.vim

curvimrc=$(ls -la ~ | grep '\.vimrc$' | wc -l)
curvimdir=$(ls -la ~ | grep '\.vim$' | wc -l)

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

echo -e "copying vim files to " ~
cp ".vimrc" "$vimrc"
cp -r ".vim" "$vimdir"
