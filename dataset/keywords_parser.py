import json

newKeywords = []
with open('keywords.json', 'r') as inFile:
    games = json.load(inFile)
    for game in games:
        for keyword in game['keywords']:
            if not keyword in newKeywords:
                newKeywords.append(keyword)
                print(keyword) 

with open('keywords_unique.json', 'w') as outfile:
    json.dump(newKeywords, outfile)
