import mmap

f = open('capture.txt')
s = mmap.mmap(f.fileno(), 0, access=mmap.ACCESS_READ)
if s.find('*&') != -1:
    print 'true'
