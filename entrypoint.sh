#!/bin/sh -l
Xvfb -screen 0 800x600x16 -ac &

cd $GITHUB_WORKSPACE

DIR="$( pwd )"
sed -i "s#addToClassPath: '.*'#addToClassPath: \'$DIR/Java-Toolbuilder/src\'#g" $DIR"/squeak-smalltalk-packages/Toolbuilder-Java.package/JavaToolBuilder.class/class/addJavaClasses.st"

/smalltalkCI/run.sh