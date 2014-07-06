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


#TESTS
#a = event("Bullet", [20, "default", 100])
#print a.toString()
#b = event("Bullet", [30, "default", 50])
#i = infoSet()
#print i.toString()
#i.addEvent(a)
#i.addEvent(b)
#print i.toString()
