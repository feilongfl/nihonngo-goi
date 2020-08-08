#!/usr/bin/env python3

from pydub import AudioSegment
from pydub.silence import split_on_silence
import os
import sys

def work(audiopath):
    # read file
    audiotype = 'mp3'
    sound = AudioSegment.from_file(audiopath, format=audiotype)
    (chunks_path, _) = os.path.splitext(audiopath)
    if not os.path.exists(chunks_path): os.mkdir(chunks_path)
    name_prefix = chunks_path.split('/')
    
    # split
    chunks = split_on_silence(sound, min_silence_len=300, silence_thresh=-70)
    
    # print('parse start')
    for i in range(len(chunks)):
        new = chunks[i]
        save_name = os.path.join( chunks_path, '%s-%s-%04d.%s'%(name_prefix[1], name_prefix[2], i, audiotype))
        new.export(save_name, format=audiotype)
        # print('%04d'%i,len(new))
    # print('parse done')

    pass


if __name__ == "__main__":
    audiopath = sys.argv[1]
    print(audiopath)

    work(audiopath)

    pass
