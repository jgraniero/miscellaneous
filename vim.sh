#!/bin/bash

timestamp=$(date +"%Y%m%d_%s")
logdir=$(pwd)/logs

# user's local paths
localVimrc=~/.vimrc
localVimdir=~/.vim
localHelperdir=~/vim-helpers
localBin="${localHelperdir}/usr/local/bin"

# paths in this repo
repoVimrc=.vimrc
repoVimdir=.vim
repoPlugindir=vim-plugins
repoHelperdir=vim-helpers

curvimrc=$(ls -la ~ | grep '\.vimrc$' | wc -l)
curvimdir=$(ls -la ~ | grep '\.vim$' | wc -l)
curhelperdir=$(ls -l ~ | grep 'vim-helpers$' | wc -l)
ctagsinstalled=$(which ctags | wc -l)

if [ -n $HOME ];
then
    home=$HOME
else
    home=$(cat /etc/passwd | grep `whoami` | awk -F ':' '{print $(NF-1)}')
fi
echo -e "determined home directory is ${home}"

# if log directory exists, delete it and recreate it so that it's empty
if [ $(ls "${logdir}/.." | grep logs | wc -l) -ne 0 ];
then
    echo -e "${logdir} exists, deleting and creating new"
    rm -rf "${logdir}"
fi

echo -e "creating ${logdir}\n"
mkdir "${logdir}"

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
if [ $curvimrc -eq 1 ];
then
    echo -e "moving $localVimrc to ${localVimrc}_$timestamp"
    mv "$localVimrc" "${localVimrc}_$timestamp"
fi

if [ $curvimdir -eq 1 ];
then
    echo -e "moving $localVimdir to ${localVimdir}_$timestamp"
    mv -f "$localVimdir" "${localVimdir}_$timestamp"
fi

if [ $curhelperdir -eq 1 ];
then
    echo -e "moving $localHelperdir to ${localHelperdir}_$timestamp\n"
    mv -f "$localHelperdir" "${localHelperdir}_$timestamp"
fi

# copy .vimrc and the skeleton .vim directory (only contains pathogen plugin)
echo -e "copying vim files to " ~ "\n"
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

# install ctags
if [ $ctagsinstalled -ne 1 ];
then
    echo -e "installing exuberant ctags to ${home}"
    set -x
    cd "$localHelperdir"
    tar -xzvf ctags* >> "${logdir}/ctags.log" 2>&1
    cd ctags*
    ./configure "--prefix=${home}/${repoHelperdir}/usr/local" >> "${logdir}/ctags.log" 2>&1
    make -s >> "${logdir}/ctags.log" 2>&1
    make -s install >> "${logdir}/ctags.log" 2>&1
    cd ..
    rm -rf ctags*
    set +x
fi
echo -e "\n"

# install php
echo -e "installing php to ${home}"
set -x
cd "$localHelperdir"
tar -xzvf php* >> "${logdir}/php.log" 2>&1
cd php*
./configure \
    -q \
    --enable-cli \
    --disable-libxml \
    --disable-dom \
    --disable-simplexml \
    --disable-xml \
    --disable-xmlreader \
    --disable-xmlwriter \
    --without-pear \
    --prefix="${home}/${repoHelperdir}/usr/local" >> "${logdir}/php.log" 2>&1
make -s >> "${logdir}/php.log" 2>&1
make -s install-cli >> "${logdir}/php.log" 2>&1
cd ..
rm -rf php*
set +x
if [[ ! $PATH =~ "${localBin}" ]];
then
    export PATH="${home}/${repoHelperdir}/usr/local/bin:${PATH}"
fi
echo -e "\n"

# install phpctags
echo -e "installing phpctags"
set -x
cd "$localHelperdir/vim-plugin-tagbar-phpctags/" && make >> "${logdir}/phpctags.log"
set +x
echo -e "\n"
