#!/bin/bash
for g in object_view; do
    echo $g
    b=`bundle show $g`
    for d in app/assets/stylesheets app/javascript; do
	echo "  $d"
	ln -sf $b/$d/$g $d/$g
    done
done
