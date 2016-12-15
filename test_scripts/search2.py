import mmap

for i in os.listdir(os.getcwd()): 
	f = open(i)
	s = mmap.mmap(f.fileno(), 0, access=mmap.ACCESS_READ)
	if s.find('AES') != -1:
	    print 'true'
	    print i 
