#!/bin/bash

# I'm too lazy to create a makefile

rgbasm -Weverything -o main.o ../main.rgbasm
rgbasm -Weverything -o sample.o sample.rgbasm
rgblink --dmg --tiny --map sample.map --sym sample.sym -o sample.gb main.o sample.o
rgbfix --title game --pad-value 0 --validate sample.gb
cp sample.gb sample.rgbasm sample.sym /Users/markd/Applications/BGB\ Emulator.app/Contents/SharedSupport/prefix/drive_c/ROMS 


