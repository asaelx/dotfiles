#!/usr/bin/python

import requests
import os.path
import json
import datetime

#path to polynews script

save_path = '/home/asaelx/.scripts/news/'

#get your api key at https://newsapi.org/
api_key = "5d598edd05f74fa1841d1ce12487e0ca"

country = "mx"
category = ""

try:
    data = requests.get('https://newsapi.org/v2/top-headlines?apiKey='+api_key+'&country='+country+'&category='+category).json()

    with open(os.path.join(save_path,"news.json"), 'w') as json_file:
        json.dump(data, json_file)

    print(datetime.datetime.now())

except requests.exceptions.RequestException as e:
    print ('Something went wrong!')

