import glob
import string
import pickle
import re
import os


path = '/Users/damiOr/Desktop/otool/*'


test=[]
for apps in glob.glob(path):
    with open(apps, "r") as f:
        line = f.read()
        newLine = line.split("Contents of ")
        testLine = str(newLine[1].split('\n'))
        
        
        match = re.findall("Meta Class", testLine, re.DOTALL)
        print apps, len(match)
        print
#print
