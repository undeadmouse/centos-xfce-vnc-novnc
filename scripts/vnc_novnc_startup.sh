#!/bin/bash

/usr/bin/vncserver -kill ${DISPLAY} > /dev/null 2>&1 || :
/sbin/runuser -l unigeo -c "/usr/bin/vncserver ${DISPLAY} -depth ${VNC_COL_DEPTH} -geometry ${VNC_RESOLUTION}"
#kill $(ps ax | grep '/usr/bin/websockify' | grep -v grep | awk '{print $1}')
/usr/bin/python /usr/bin/websockify --web /usr/bin/../share/novnc/ ${NOVNC_PORT} localhost:${VNC_PORT} &
