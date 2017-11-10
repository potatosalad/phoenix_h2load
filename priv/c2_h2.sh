#!/usr/bin/env bash

rrdtool graph c2_h2.svg \
--width 600 \
--height 200 \
--start 00:00 \
--end start+58seconds \
--title 'cowboy 2.x (h2)' \
--vertical-label 'requests per second' \
--imgformat SVG \
--border 0 \
--font DEFAULT:0:Consolas \
--upper-limit 70000 \
--lower-limit 0 \
--rigid \
'DEF:phxrequests=c2_h2_phoenix.rrd:requests:MAX:start=1510247887:end=1510247947:step=1' \
'DEF:plgrequests=c2_h2_plug.rrd:requests:MAX:start=1510247805:end=1510247865:step=1' \
'DEF:cowrequests=c2_h2_cowboy.rrd:requests:MAX:start=1510248667:end=1510248727:step=1' \
'SHIFT:phxrequests:-37088' \
'SHIFT:plgrequests:-37006' \
'SHIFT:cowrequests:-37868' \
'CDEF:phxln=phxrequests,phxrequests,UNKN,IF' \
'CDEF:plgln=plgrequests,plgrequests,UNKN,IF' \
'CDEF:cowln=cowrequests,cowrequests,UNKN,IF' \
'VDEF:phxrequestsmax=phxrequests,MAXIMUM' \
'VDEF:phxrequestsmin=phxrequests,MINIMUM' \
'VDEF:phxrequestsavg=phxrequests,AVERAGE' \
'VDEF:phxrequestsstd=phxrequests,STDEV' \
'VDEF:plgrequestsmax=plgrequests,MAXIMUM' \
'VDEF:plgrequestsmin=plgrequests,MINIMUM' \
'VDEF:plgrequestsavg=plgrequests,AVERAGE' \
'VDEF:plgrequestsstd=plgrequests,STDEV' \
'VDEF:cowrequestsmax=cowrequests,MAXIMUM' \
'VDEF:cowrequestsmin=cowrequests,MINIMUM' \
'VDEF:cowrequestsavg=cowrequests,AVERAGE' \
'VDEF:cowrequestsstd=cowrequests,STDEV' \
'AREA:cowrequests#54ec48: cowboy\l' \
'COMMENT:\u' \
'GPRINT:cowrequestsavg:AVG %6.0lf' \
'GPRINT:cowrequestsmin:MIN %6.0lf' \
'GPRINT:cowrequestsmax:MAX %6.0lf' \
'GPRINT:cowrequestsstd:STDEV %6.0lf\r' \
'AREA:plgrequests#48c4ec: plug\l' \
'COMMENT:\u' \
'GPRINT:plgrequestsavg:AVG %6.0lf' \
'GPRINT:plgrequestsmin:MIN %6.0lf' \
'GPRINT:plgrequestsmax:MAX %6.0lf' \
'GPRINT:plgrequestsstd:STDEV %6.0lf\r' \
'AREA:phxrequests#7648ec: phoenix\l' \
'COMMENT:\u' \
'GPRINT:phxrequestsavg:AVG %6.0lf' \
'GPRINT:phxrequestsmin:MIN %6.0lf' \
'GPRINT:phxrequestsmax:MAX %6.0lf' \
'GPRINT:phxrequestsstd:STDEV %6.0lf\r' \
'LINE1:phxln#4d18e4' \
'LINE1:plgln#1598c3' \
'LINE1:cowln#24bc14'
