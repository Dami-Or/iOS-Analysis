import re
import math
import glob
from sys import argv


target = open("symresults.txt", 'w')

totintcount = 0
linenum = 0
totexternalcount = 0
appnumber = 0

path = '/Users/nicholasmusella/Documents/EC700/E3/autotest2/nmtext/*.txt'

   
for apps in glob.glob(path):
    
    internalcount = 0
    #linenum = 0
    externalcount = 0

    file = open(apps)

    print apps
    appnumber +=1

    for line in file:
        linenum += 1
        if re.match(r'\A[0-9]', line):
            #print line
            internalcount +=1
            totintcount +=1
        else: 
            externalcount +=1
            totexternalcount +=1


    #print "Internal Symbols: ", internalcount
    #print "External Symbols: ", externalcount
    #print "Total Symbols: ", linenum

    #internalperc = round(100.0 * internalcount / linenum, 0)
    #externalperc = round(100.0 * externalcount / linenum, 0)
    #print "Percent of Internal: " , internalperc
    #print "Percent of External: ", externalperc

totint = str(totintcount)
totext = str(totexternalcount)
totapp = str(appnumber)
totline = str(linenum)
print "Internal: ", totintcount
target.write ('Total Internal Used: ' + totint + '\n')
target.write ('Total External Used: ' + totext + '\n')	
target.write ('Total # of Apps: ' + totapp + '\n')

target.close()
print linenum

