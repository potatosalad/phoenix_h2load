#!/usr/bin/env bash

rrdtool graph c1_h1_phoenix.req.svg \
--width 600 \
--height 200 \
--start 00:00 \
--end start+60seconds \
--title 'c1_h1_phoenix' \
--vertical-label 'requests per second' \
--imgformat SVG \
--border 0 \
--font DEFAULT:0:Consolas \
--upper-limit 70000 \
--lower-limit 0 \
--rigid \
'DEF:error=c1_h1_phoenix.rrd:error:MAX:start=1510522581:end=1510522641:step=1' \
'DEF:requests=c1_h1_phoenix.rrd:requests:MAX:start=1510522581:end=1510522641:step=1' \
'SHIFT:error:-52581' \
'SHIFT:requests:-52581' \
'CDEF:ln1=requests,requests,UNKN,IF' \
 \
'TICK:error#e60073a0:1:  Error' \
'AREA:requests#7648eca0: req/s\l' \
'LINE1:ln1#4d18e4' \
'VDEF:requestsmax=requests,MAXIMUM' \
'VDEF:requestsmin=requests,MINIMUM' \
'VDEF:requestsavg=requests,AVERAGE' \
'COMMENT:\u' \
'GPRINT:requestsavg:AVG %6.0lf' \
'GPRINT:requestsmin:MIN %6.0lf' \
'GPRINT:requestsmax:MAX %6.0lf\r'
