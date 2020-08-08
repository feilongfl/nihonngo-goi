#!/usr/bin/env fish

function lsdir
    ls -l $argv |grep "^d" |awk '{print $9}'
end

# parse json dict
find . -name "*.json" | grep -v '.vscode' | xargs -n1 -P(nproc) ./parse.sh

for f in (lsdir .)
    pushd $f
    cat *.csv > summary.txt
    rm *.csv
    popd
end

# cut audio
find . -name "*.mp3" | xargs -n1 -P(nproc) ./vparse.py

# move audio file to same folder
mkdir output
for f in (lsdir . | grep -v output)
    for sf in (lsdir $f)
        mv ./$f/$sf/* output/
    end
end

# gen audio info
for f in (lsdir . | grep -v output)
    # remove header
    ls output | grep $f | sort -n -t '-' -k 2 | grep -v 000[01].mp3 | grep -v 1-000[23].mp3 > $f/audiotree.txt.origin
    # gen last id list
    for d in (cat $f/audiotree.txt.origin | cut -d '-' -f 2 | sort -u)
        cat $f/audiotree.txt.origin | grep $f-$d | sort -n -t '-' -k 3 -r | head -n 1 >> $f/audiotree.txt.last
    end
    sort -o $f/audiotree.txt.last -n -t '-' -k 2 $f/audiotree.txt.last

    # uniq data
    awk '{print $0}' $f/audiotree.txt.origin $f/audiotree.txt.last | sort -n -t '-' -k 2 | uniq -u > $f/audiotree.txt
    rm $f/audiotree.txt.last
    rm $f/audiotree.txt.origin
end

for f in (lsdir . | grep -v output)
    pushd $f
    paste summary.txt audiotree.txt > summary-audio.txt
    popd
end
