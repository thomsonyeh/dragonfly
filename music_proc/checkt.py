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


def get_track(filename):
    f = open (filename)
    t = track.track_from_filename(filename)
    return t

def play_song(filename):
    music = pyglet.resource.media(filename)
    music.play()
    pyglet.app.run()


def calc_sect_avg(t):
    sect = t.sections
    segs = t.segments

    l = []

    for s in sect:
        segsHere = []
        end = s['start']+s['duration']
        while (0 < len(segs)) and (segs[0]['start'] < end):
            segsHere.append(segs[0]['loudness_max'])
            del segs[0]
        if len(segsHere) != 0:
            l.append((s['start'], s['duration'], (sum(segsHere)/len(segsHere))))

    return l

def tatum_to_list(tat):
    l=[]
    for i in tat:
        l.append(i['start'])
    return l

def is_in_tlist(x,l,trshld):
    for i in l:
        if abs(x-i)<=trshld:
            return True
    return False

def louder(x,t,l):
    for (i,j,k) in l:
        if t>=i and t<=i+j:
            cmper = k
            break
    return x>cmper
    
def beats_to_list(b):
    l=[]
    for i in b:
        l.append(i['start'])
    return l


from string import *

class event:
    def __init__(self, eventType, pl):
        self.paramList = [eventType]
        for p in pl:
            self.paramList.append(p)

    def toString(self):
        return join([str(p) for p in self.paramList], "::")

class infoSet:
    def __init__(self):
        self.eventList = []

    def addEvent(self, b):
        self.eventList.append(b)

    def toString(self):
        s = join([b.toString() for b in self.eventList], "<>")
        return s


import sys
t=get_track(sys.argv[1])


       
confidences = set([])
durations = set([])


"""
beats=t.beats
segs=t.segments
for i in segs:
    confidences.add(i['confidence'])
    durations.add(i['duration'])

print confidences
print durations
"""

#thread = Thread(target=play_song, args=["abc.mp3"])
#thread.start()
#print "Threading"
import time
i=0

#calc_sect_avg(t);

beats=t.beats
segs=t.segments


tlist = tatum_to_list(t.tatums)
sectavg = calc_sect_avg(t)
#sectavg=[(0,0,0)]


i=0

t=get_track(sys.argv[1])
segs=t.segments
bullist=[]
for i in range(len(segs)):
    start= segs[i]['start']
    lm=segs[i]['loudness_max']
    li=segs[i]['loudness_start']
    #print t.tatums[i]['start']
    """    and louder((lm+li)/4.0,start,sectavg)"""
    if (is_in_tlist(start,tlist,0.065)) or louder((lm+2*li),start,sectavg):
#   if (is_in_tlist(start,tlist,0.05)) or louder((lm+2*li),start,sectavg):
        bullist.append(start);
        #print segs[i]['start'], "start:",segs[i]['loudness_start'], "max:",segs[i]['loudness_max'], "louddiff:", segs[i]['loudness_max']-segs[i]['loudness_start'],"timediff:",(segs[i]['loudness_max_time']), "TLIST:",is_in_tlist(segs[i]['start'],tlist,0.05)
    

def serialize_sect_list(l):
    newl=[]
    for (i,j,k) in l:
        newl.append((i,i+j,60+k))
    return newl


beatlist = beats_to_list(t.beats)
ssl = serialize_sect_list(sectavg)
"""
thread = Thread(target=play_song, args=[sys.argv[1]])
thread.start()
print "Threading"
import time
#time.sleep(3)
o=0
basetime= time.time()
while (True):
    cur_t= time.time()-basetime
    if bullist[0]-cur_t<=0.05:
        print o,o,o,o,o,o,o,o,o
        o=(o+1)%2
        bullist=bullist[1::]
    if beatlist[0]-cur_t<=0.05:
        print "*"
    time.sleep(0.03);
"""



info = infoSet()
while (bullist != [] and beatlist != [] and ssl != []):
    if len(bullist) != 0:
		a = bullist[0]
    else:
        a = 9999
    if len(beatlist) != 0:
        b = beatlist[0]
    else:
        b = 9999
    if len(ssl) != 0:
        c = ssl[0]
    else:
        c = (9999, 9999, 0)
    if a < b:
        if c[0] < a:
            info.addEvent(event("section", [p for p in c]))
            del ssl[0]
        else:
            info.addEvent(event("bullet", [a, 20, 0]))
            del bullist[0]
    else:
        if c[0] < b:
            info.addEvent(event("section", [p for p in c]))
            del ssl[0]
        else:
            info.addEvent(event("bullet", [b, 5, 1]))
            del beatlist[0]

print info.toString()

#print bullist,beatlist,serialize_sect_list(sectavg)
"""
outstr=""
for (i,j,k) in sectavg:
    outstr=outstr+ "("+str(i)+":"+str((i+j))+":"+str((60+k))+"),"
outstr=outstr[:-1]

"""
#print bullist,"###",beatlist,"###",outstr


"""
thread = Thread(target=play_song, args=[sys.argv[1]])
thread.start()
print "Threading"
import time
#time.sleep(3)
o=0
basetime= time.time()
while (True):
    cur_t= time.time()-basetime
    if bullist[0]-cur_t<=0.05:
        print o,o,o,o,o,o,o,o,o
        o=(o+1)%2
        bullist=bullist[1::]
    if beatlist[0]-cur_t<=0.05:
        print "*"
    time.sleep(0.03);

"""
