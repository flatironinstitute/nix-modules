#!/bin/bash -e
. /etc/profile.d/modules.sh
module purge
for (( i=0 ; i<$# ; i++ )) ; do
	if [[ ${!i} == -- ]] ; then
		break
	fi
done
if [[ $i -lt $# ]] ; then
	module add "${@:1:$[i-1]}"
	shift $i
elif [[ $# -gt 1 ]] ; then
	module add "$1"
	shift
else
	echo >&2 "Usage: $0 MODULES.. [--] CMD [ARGS..]"
	exit 2
fi
exec "$@"
