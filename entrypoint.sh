#!/bin/sh -l
Xvfb -screen 0 800x600x16 -ac &
cd $GITHUB_WORKSPACE
/smalltalkCI/run.sh