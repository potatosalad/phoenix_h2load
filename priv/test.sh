#!/usr/bin/env bash

if [ $# -lt 4 ]; then
	echo 1>&2 "$0: requires an DURATION, WARM_UP_TIME, TYPE=(h1|h2), and TARGET argument"
	exit 2
fi

duration="$1"
warm_up_time="$2"
type="$3"
target="$4"

extra_args=""

if [[ "${type}" == "h1" ]]; then
	extra_args="--h1"
else
	extra_args="--max-concurrent-streams=10"
fi

set -x

exec h2load \
${extra_args} \
--duration="${duration}" \
--warm-up-time="${warm_up_time}" \
--clients=100 \
--requests=0 \
"${target}" | awk '/progress: 100%/{y=1;next}y'
