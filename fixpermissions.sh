#!/bin/bash
# This was lifted from somewhere on the internet, and modified to work with Apple's stat tool

TREE1="$1"
TREE2="$2"
stat='/usr/bin/stat -r'

find "$TREE1" \( -type d -o -type f \) -print | \
	while IFS= read -r src ; do
		tgt="${TREE2}${src#${TREE1}}"
		if [ -f "$tgt" -o -d "$tgt" ]; then
			echo "SRC: ${src} TGT: ${tgt}"
			stat1=`${stat} "${src}"`
			x1=`echo ${stat1} | cut -f 3,5,6 -d " "`
			set -- ${x1}
			p1=`echo "$1"`
			o1=`echo "$2"`
			g1=`echo "$3"`

			stat2=`${stat} "${tgt}"`
			x2=`echo ${stat2} | cut -f 3,5,6 -d " "`
			set -- ${x2}
			p2=`echo "$1"`
			o2=`echo "$2"`
			g2=`echo "$3"`

			if [ ${p1} != ${p2} ]; then
				( echo old perms were ${p2} new perms are ${p1} ; set -x ; chmod "${p1}" "${tgt}" )
			fi
			if [ ${o1} != ${o2} ]; then
				( echo old owner was ${o2} new owner is ${o1} ; set -x ; chown "${o1}" "${tgt}" )
			fi
			if [ ${g1} != ${g2} ]; then
				( echo old group was ${g2} new group is ${g1} ; set -x ; chgrp "${g1}" "${tgt}" )
			fi
		fi
	done
