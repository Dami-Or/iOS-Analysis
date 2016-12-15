import glob
import string
import pickle

def parse():
	lines=[]

	path = '/iOS/resultsAnalysis/symbols/*.txt'	

	for apps in glob.glob(path):
		with open (apps, "r") as f :
			lines = f.read().splitlines()
		libraries=[]
		str=[]
		for line in lines:
			if "from" in line:
				str=line.split("from")
				print( str)
				libraries.append(str[1])
		
				str=[]
	with open ("output.txt", "w") as f1:
		pickle.dump(libraries,f1)
						

parse()
