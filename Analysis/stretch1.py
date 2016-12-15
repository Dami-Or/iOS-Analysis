import glob
import string
import pickle
import re
import os


path = '/Users/damiOr/Desktop/symbols/*'

thrid=['Swiftz','libswiftGLKit','KVOController','libswiftDispatch','libswiftSpriteKit','libswiftObjectiveC','libswiftCoreMedia','libc','libz','Cartography','libswiftSecurity','libswiftCoreLocation','SwiftTweaks','ContactsUI','libswiftEventKit','WatchKit','libswiftCore','libstdc','libswiftCoreAudio','libswiftsimd','MagicalRecord','libPhoneNumber','PMKVObserver','SSKeychain','libswiftCoreGraphics','PMKUtilities','PostmatesUI','PMJSON','libswiftWatchConnectivity','libswiftFoundation','libiconv','Result','libswiftCoreData','Contacts','libSystem','DominosKit','PMHTTP','OnePasswordExtension','libextension','libxml2','SockPuppetGizmo','libobjc','libswiftContacts','PMKCore','Mantle','WatchConnectivity','libgcc','CocoaLumberjack','libswiftPassKit','libswiftWatchKit','libswiftAVFoundation','CoreSpotlight','libswiftAssetsLibrary','libswiftUIKit','libicucore','KHACore','libswiftSceneKit','ReactiveCocoa','libswiftCoreImage','libswiftDarwin','libsqlite3','libSystemfrom']

var=[]

test=[]


for apps in glob.glob(path):
    print apps
    with open(apps, "r") as f:
        line = f.read()
        match = re.findall("from\s\w+", line, re.DOTALL)
        if match:
            var= ' '.join(match).split('from ')
            test.append(var)
            
            #for i in test:
            #   print i
            testSt=''.join(str(test))
            temp=set(thrid)
            for a in temp:
                if a in testSt:
                   print a
            print  
		





			