# Dami Orikogbo EC700 Sp '16
#Using regex to find potential static keys within unencrypted iOS apps


import re
import glob
import os
import pickle
import datetime


path = '/iOS/resultsAnalysis/strings/*'


iOSKeys = []


DEBUG = False

def findKey (decApp):
    if textRessemblesKey(decApp):
        keyType = keyTypeDetection(decApp)
        return [True, keyType];
        
    return [False, None];

def keyTypeDetection(decApp):
    return None;

def textRessemblesKey(decApp):
    potentialKey = inQuotes(decApp)
    potentialKey = str(potentialKey)
    if potentialKey != False:
        if lengthNotAppropriate(potentialKey):
            return False;
            
            syms = symbolCount(potentialKey)
            letter   = uniqueLetterCount(potentialKey)
            lowerCase = uniqueLowerCaseCount(potentialKey)
            nums = numberCount(potentialKey)
            upCase = uniqueUpperCaseCount(potentialKey)



# Regular Expressions Search within app


        if re.findall(r'[\d]*_[\w]*', potentialKey):
            if DEBUG:
                print ""
            return False
                    

        if re.findall(r'[\w]*_[\d]*', potentialKey):
            if DEBUG:
                print ""
            return



# Things that are most likely NOT keys

        if repeatSymbols(potentialKey):
            if DEBUG:
                print "Detected: Repeating symbols"
            return False


        if "/" in potentialKey:
            if DEBUG:
                print " Detected: "
            return False

        if "\\" in potentialKey:
            if DEBUG:
                print "Detected: Seperator & Repeating"
            return False


        if consecLetters(potentialKey):
            if DEBUG:
                print "Detected: Consec #s"
            return False


        if increasingLetter(potentialKey):
            if DEBUG:
                print "Detected: Not random key"
            return False


        fileExtension = potentialExt(potentialKey)
        if fileExtension:
            if DEBUG:
                print "Detected: File Ext."
            return False



        if nums == len(potentialKey):
            if DEBUG:
                print "Detected nums: Password or Key"
            return True;


        if upCase == letter and nums > 2:
            if DEBUG:
                print "Detected: all UPPER ... key?"
            return True;
                
    return False;


def inQuotes(decApp):
    result = re.findall(r'"([^"]*)"', decApp)
    if result:
        if DEBUG:
            print "potentialKey string = " + result[0] + " from " + decApp
        return result[0];
    if DEBUG:
        print "Error - "+ str(decApp)
    return False;

def uniqueLetterCount(decApp):
    arr = []
    for i in decApp:
        if i.isalpha() and not i in arr:
            arr.append(i)
    if DEBUG:
        print "uniqueLetterCount = " + str(len(arr))
    return len(arr);


def lengthNotAppropriate(decApp):
    if len(decApp) < 20 or len(decApp) > 200:
        if DEBUG:
            print "Wrong Length"
        return True;
    if DEBUG:
        print "Length is ok"
    return False

def numberCount(decApp):
    digit = 0
    for i in decApp:
        if i.isdigit():
            digit += 1
    if DEBUG:
        print "NumberCount of " + decApp + " = " + str(digit)
    return digit;


def hasSpaces (decApp):
    if ' ' in decApp:
        if DEBUG:
            print "Has spaces."
        return True;
    if DEBUG:
        print "No spaces."
    return False;


def lengthIsLessThan10(decApp):
    if len(decApp) < 10:
        if DEBUG:
            print "Length is < 10"
        return True;
    if DEBUG:
        print "Length is > 10"


def symbolCount(decApp):
    symbolCount = 0
    for i in decApp:
        if i.isalnum() == False:
            symbolCount += 1
    if DEBUG:
        print "symbolCount = " + str(symbolCount)
    return symbolCount;


def uniqueLowerCaseCount(decApp):
    arr = []
    for i in decApp:
        if i.isalpha() and not i in arr and i.islower():
            arr.append(i)
    if DEBUG:
        print "uniqueLowerCaseCount of = " + str(len(arr))
    return len(arr);

def uniqueUpperCaseCount(decApp):
    arr = []
    for i in decApp:
        if i.isalpha() and not i in arr and i.isupper():
            arr.append(i)
    if DEBUG:
        print "uniqueUpperCaseCount of = " + str(len(arr))
    return len(arr)

def potentialExt(potentialKey):
    count = potentialKey.count('.')
    if count > 1:
        return True
    elif count == 1:
        loc = potentialKey.index('.')
        if DEBUG:
            print potentialKey
            print "length of fileExtension = "+str((len(potentialKey) - loc))
            print "fileExtension =" + str((len(potentialKey) - loc) < 8)
            if (len(potentialKey) - loc) < 6:
                return True
    
        return False

def increasingLetter(decApp):
    for x in xrange(len(decApp)):
        try:
            if (ord(decApp[x])+1) == ord(decApp[x+1]):
                if (ord(decApp[x+1])+1) == ord(decApp[x+2]):
                    if DEBUG:
                        print "Detected: Incrementing letters"
                    return True
        except:
            pass
        try:
            if (ord(decApp[x])+1) == ord(decApp[x+1]):
                if (ord(decApp[x+1])-1) == ord(decApp[x+2]):
                    if DEBUG:
                        print "Detected: decrementing letters"
                    return True
        except:
            pass
    return False


def repeatSymbols(decApp):
    arr = []
    for i in decApp:
        if (i.isalnum() == False) and not i in arr:
            arr.append(i)
        elif i in arr:
            return True
    return False





for apps in glob.glob(path):
        with open(apps, "r") as f:
                line = f.read()
                print apps
                found_Key = findKey(line)

                if found_Key:
                        print " Detected Keys:", found_Key
                        print 


