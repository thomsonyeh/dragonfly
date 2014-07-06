#Other Imports
import sys


#Echonest imports
from pyechonest import song
from pyechonest import artist
from pyechonest import track

from pyechonest import config
config.ECHO_NEST_API_KEY="OEHPCRVVLZ9EU5FYW"

#Sound stuff
import pyglet

#Threading
from threading import Thread
import time




def get_tempo(artist, title):
    "gets the tempo for a song"
    results = song.search(artist=artist, title=title, results=1, buckets=['audio_summary'])
    if len(results) > 0:
        return results[0].audio_summary['tempo']
    else:
        return None


def search_artist(name):
    weezer_results = artist.search(name)
    weezer = weezer_results[0]
    weezer_blogs = weezer.blogs
    print 'Blogs about weezer:', [blog.get('url') for blog in weezer_blogs]

def get_track(filename):
    f = open (filename)
    t = track.track_from_filename(filename)
    return t

def play_song(filename):
    music = pyglet.resource.media(filename)
    music.play()
    pyglet.app.run()


print "Functions:"
print "get_tempo(artist,title)"
print "search_artist(artist)"
print "getTrack(filename)"


import sys

song=sys.argv[1]
print song


t=get_track(song)


       
confidences = set([])
durations = set([])



beats=t.beats

for i in beats:
    confidences.add(i['confidence'])
    durations.add(i['duration'])

print confidences
print durations

"""
thread = Thread(target=play_song, args=[song])
thread.start()
print "Threading"

"""
raw_input ()
print "A"
import time
#time.sleep(3)
basetime= time.time()
while (True):
    cur_t= time.time()
    #print cur_t-basetime
    #print beats[1]['start'] - (cur_t-basetime) 
    """
    if (beats[0]['start'] - (cur_t-basetime))<=0.01:
            if beats[0]['confidence']<0.4:
                print ""
            elif (beats[0]['confidence']>0.6):
                print "O"
            elif beats[0]['confidence']>=0.4:
                print "o"
            beats=beats[1::]
    time.sleep(0.0001)
    """
    segs=t.segments
    a=segs[0]
    lm=a['loudness_max'] 
    li=a['loudness_start']
    if (segs[0]['start'] - (cur_t-basetime))<=0.01:
        if (li>-20) and (li <= lm):
            print "4"
        t.segments=t.segments[1::]
        time.sleep(0.05)
    """
    segs=t.segments
    
    if (segs[0]['start'] - (cur_t-basetime))<=0.03:
        print "1"   
    
        segs=segs[1::]
        time.sleep(0.0001)
#
    """
#thread2 = Thread(target=doit, args=[])
#thread.start()
