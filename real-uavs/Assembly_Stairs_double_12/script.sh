#!/bin/bash

cd 2nd/
 ffmpeg -framerate 10 -pattern_type glob -i "*.jpg" SA6_2ndblock.mp4
cd ..

cd 3rd/
ffmpeg -framerate 10 -pattern_type glob -i "*.jpg" SA6_3rdblock.mp4
cd ..

cd 4th/
ffmpeg -framerate 10 -pattern_type glob -i "*.jpg" SA6_4thblock.mp4
cd ..

cd 5th/
ffmpeg -framerate 10 -pattern_type glob -i "*.jpg" SA6_5thblock.mp4
cd ..

cd 6th/
ffmpeg -framerate 10 -pattern_type glob -i "*.jpg" SA6_6thblock.mp4
cd ..

