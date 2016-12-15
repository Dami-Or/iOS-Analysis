import re
import math

internalcount = 0
linenum = 0
externalcount = 0

path = '/iOS/resultsAnalysis/symbols/*.txt'
   
for apps in glob.glob(path):
   file = open(path)
    for line in file:
        linenum += 1
        if re.match(r'\A[0-9]', line):
            print line
            internalcount +=1
        else: 
            externalcount +=1


    print "Internal Symbols: ", internalcount
    print "External Symbols: ", externalcount
    print "Total Symbols: ", linenum

    internalperc = round(100.0 * internalcount / linenum, 0)
    externalperc = round(100.0 * externalcount / linenum, 0)
    print "Percent of Internal: " , internalperc
    print "Percent of External: ", externalperc	
