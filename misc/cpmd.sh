#!/bin/bash

path=$PWD
code_root=${path%%docs*}
cp $code_root/m.md ./$1
