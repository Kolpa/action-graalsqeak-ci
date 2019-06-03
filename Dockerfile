FROM oracle/graalvm-ce

RUN gu install -u https://www.hpi.uni-potsdam.de/hirschfeld/artefacts/graalsqueak/graalsqueak-component-0.8.2-for-19.0.0.jar

RUN yum install -y xorg-x11-server-Xvfb libXrender libXtst

ENV DISPLAY=:0

LABEL "com.github.actions.name"="Test Graalsqueak"
LABEL "com.github.actions.description"="Run tests from graalsqueak"
LABEL "com.github.actions.icon"="terminal"
LABEL "com.github.actions.color"="purple"

ADD entrypoint.sh /entrypoint.sh
ADD smalltalkCI /smalltalkCI
ADD graalsqueak-0.8 /graalsqueak-0.8

ENTRYPOINT [ "/entrypoint.sh" ]