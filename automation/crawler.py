from bs4 import BeautifulSoup

import requests
import string 
import re
import pickle 
import time

def bsoup(url):
	source_code=requests.get(url)
        plain_text=source_code.text
        soup=BeautifulSoup(plain_text)
	return soup

def get_categories(url):
	categories=[]
	soup=bsoup(url)
	for link in soup.findAll("a", {"class":"top-level-genre"}):
		href=link.get("href")
		categories.append(href)
	return categories

def alph(categories,letters_star):
	list_alpha=[]
	for link in categories:
		for symbol in letters_star:
			new_url=link+"&letter="+symbol
			time.sleep(30)
			pages(new_url)
def pages(url):	
	pages=1
	links=[]
	while (True):
		new_url=url+"&page="+str(pages)+"#page"
        	soup=bsoup(new_url)
		genre=soup.find("ul",{"class":"list paginate"})	
		if genre.find("a",{"class":"paginate-more"}) is None:
			pages=1
			apps(set(links))
			break
		for link in genre.findAll("a"):
			links.append(link.get("href"))
		genre=None 
		pages=pages+1

			
def main():	
	url="https://itunes.apple.com/us/genre/ios/id36?mt=8"
	list_categories=get_categories(url)
	letters_star=list(string.ascii_uppercase)
	letters_star.append("*")
	alph(list_categories,letters_star)

if __name__ == "__main__":
    main()
