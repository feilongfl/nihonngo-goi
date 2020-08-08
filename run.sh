#!/usr/bin/env fish

find . -name "*.json" | grep -v '.vscode' | xargs -n1 -P(nproc) ./parse.sh

for f in (ls -l |grep "^d" |awk '{print $9}')
    pushd $f
    cat *.csv > summary.done
    rm *.csv
    popd
end

find . -name "*.mp3" | xargs -n1 -P(nproc) ./vparse.py

