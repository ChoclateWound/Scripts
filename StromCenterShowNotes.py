#!/usr/bin/python3
# Script to download show notes from sans strom center podcast
# Asks users for number of episodes to download
# Creates html file output
from urllib.request import urlopen as uReq
from bs4 import BeautifulSoup as soup
import re
import sys

def LatestEpi():
    url = 'https://isc.sans.edu/podcastdetail.html'
    uClient = uReq(url)
    pageContent = uClient.read()
    uClient.close()

    # html parsing
    page_soup = soup(pageContent, "html.parser")

    # Extract Latest Episode ID
    tempId = page_soup.findAll('meta')
    lepiID = (str(tempId[22]).split("id=")[1].split('"')[0])
    return lepiID

# Calculate show ids.
def CountShowIds(epiCount,lepiID):
    urlList = []
    counter = 1
    y = 0
    while counter <=epiCount:
        n = lepiID - y
        y +=2
        url = 'https://isc.sans.edu/podcastdetail.html?id=%s' % (n)
        counter +=1
        urlList.append(url)

    return(urlList)


# parse url and extract data
def SansParsers(urlList):
    #print(urlList)
    # sys.stdout = open("sans.html", "w")
    result = ''
    numberOfResults = 0
    for url in urlList:
        # print(url)
        uClient = uReq(url)
        pageContent = uClient.read()
        uClient.close()

        # html parsing
        page_soup = soup(pageContent, "html.parser")
        # Extract Headings & URLs
        showNotes = page_soup.blockquote
        dailyLinks = showNotes.find_all('a')

        heading = []
        links = []

        counter = 0
        for i in showNotes.contents:
            if i != ' ':
                try:
                    # Extract Headings
                    header = i.strip()
                    # Extract URL
                    links = dailyLinks[counter].text
                    # Extract Date of episode
                    date = page_soup.h2.text.split(',')[1].strip()
                    print("* %s - <a href='%s' target=_blank>%s</a><br />" % (date, links, header))
                    result += "* %s - <a href='%s' target=_blank>%s</a><br />" %(date,links,header)
                    counter +=1
                    numberOfResults +=1

                except:
                    continue

    # sys.stdout.close()
    TempFile = open("SANS.html", "w")
    TempFile.write(result)
    TempFile.close()

    #showInfo = date,header,links,lepiID
    return(numberOfResults)

def main():
    epiCount = int(input("How many episodes you want to download?"))
    LatestEpi()
    lepiID = int(LatestEpi())
    print("[*] Latest Sans EpisodeID is ", lepiID)
    urlList=CountShowIds(epiCount,lepiID)
    print("[*] Downloading Urls! Hang Tight!")
    numberOfResults = SansParsers(urlList)
    print("[*] Finished ", numberOfResults, "completed!")


if __name__ == main():
    main()
