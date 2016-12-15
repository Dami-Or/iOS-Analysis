
import glob
import string
import pickle
import re
import os

iOS = ['Accelerate','Accounts','AddressBook','AddressBookUI','AdSupport','AssetsLibrary','AudioToolbox','AudioUnit','AVFoundation','AVKit','CFNetwork','CloudKit','CoreAudio','CoreAudioKit','CoreBluetooth','CoreData','CoreFoundation','CoreGraphics','CoreImage','CoreLocation','CoreMedia','CoreMIDI','CoreMotion','CoreTelephony','CoreText','CoreVideo','EventKit','EventKitUI','ExternalAccessory','Foundation','GameController','GameKit','GLKit','GSS','HealthKit','HomeKit','iAd','ImageIO','IOKit','JavaScriptCore','LocalAuthentication','MapKit','MediaAccessibility','MediaPlayer','MediaToolbox','MessageUI','Metal','MobileCoreServices','MultipeerConnectivity','NetworkExtension','NewsstandKit','NotificationCenter','OpenAL','OpenGLES','PassKit','Photos','PhotosUI','PushKit','QuartzCore','QuickLook','SafariServices','SceneKit','Security','Social','SpriteKit','StoreKit','SystemConfiguration','Twitter','UIKit','VideoToolbox','WebKit']

apps = ['AVFoundation','AVKit','Accelerate','Accounts','AdSupport','AddressBook','AddressBookUI','AssetsLibrary','AudioToolbox','CFNetwork','Cartography','CloudKit','CocoaLumberjack','Contacts','ContactsUI','CoreBluetooth','CoreData','CoreFoundation','CoreGraphics','CoreImage','CoreLocation','CoreMedia','CoreMotion','CoreSpotlight','CoreTelephony','CoreText','CoreVideo','DominosKit','EventKit','EventKitUI','ExternalAccessory','Foundation','GLKit','GameKit','ImageIO','JavaScriptCore','KHACore','KVOController','LocalAuthentication','MagicalRecord','Mantle','MapKit','MediaPlayer','MessageUI','MobileCoreServices','NetworkExtension','NewsstandKit','NotificationCenter','OnePasswordExtension','OpenAL','OpenGLES','PMHTTP','PMJSON','PMKCore','PMKUtilities','PMKVObserver','PassKit','Photos','PostmatesUI','PushKit','QuartzCore','QuickLook','ReactiveCocoa','Result','SSKeychain','SafariServices','SceneKit','Security','Social','SockPuppetGizmo','SpriteKit','StoreKit','SwiftTweaks','Swiftz','SystemConfiguration','Twitter','UIKit','VideoToolbox','WatchConnectivity','WatchKit','WebKit','iAd','libPhoneNumber','libSystem','libSystem','libSystemfrom','libc','libextension','libgcc','libiconv','libicucore','libobjc','libobjc','libsqlite3','libsqlite3','libstdc','libswiftAVFoundation','libswiftAssetsLibrary','libswiftContacts','libswiftCore','libswiftCoreAudio','libswiftCoreData','libswiftCoreGraphics','libswiftCoreImage','libswiftCoreLocation','libswiftCoreMedia','libswiftDarwin','libswiftDispatch','libswiftEventKit','libswiftFoundation','libswiftGLKit','libswiftObjectiveC','libswiftPassKit','libswiftSceneKit','libswiftSecurity','libswiftSpriteKit','libswiftUIKit','libswiftWatchConnectivity','libswiftWatchKit','libswiftsimd','libxml2','libz']


native=[]
third=[]

temp = set(apps)
for feat in temp:
	if feat in iOS:
		native.append(feat)
	else:
		third.append(feat)

print "DEV Frameworks:  "
for i in native:
	print i

print 
print
print
print "3rd Party Frameworks:  "
for s in third:
	print s

