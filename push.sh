#!/usr/bin/env bash

rm .vimrc
cp ~/.vimrc .
git add .vimrc
git commit
git push origin master
