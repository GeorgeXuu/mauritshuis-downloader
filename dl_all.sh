#!/bin/bash

prefix=http://www.mauritshuis.nl
for current in {1..29}
do
  URL=https://www.mauritshuis.nl/en/our-collection/?p=$current
  cat /dev/null > index.html
  wget -O index.html $URL
  awk '/^<a href="/ { print } /<img src="/ { print }' index.html | sed -e 's/<a href="\(.*\)\/".*/\1/' | sed -e 's/.*<img src="\(.*\)?.*/\1/' | sed -e '/footer_bkg/d' > 123
  while mapfile -t -n 2 ary && ((${#ary[@]}));
  do
    # real_name now contain no extension
    real_name=${ary[0]##*/}
    path="$prefix${ary[1]}"
    EXTENSION=`echo "${ary[1]}" | cut -d'.' -f2`
    real_name="$real_name.$EXTENSION"
    wget -O $real_name $path
  done < 123
done
