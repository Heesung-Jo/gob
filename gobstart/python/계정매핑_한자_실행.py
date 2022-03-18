# -*- coding: utf-8 -*-
"""
Created on Thu Oct 14 11:21:06 2021

@author: gocho
"""
import urllib.request
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import requests
import re
from PIL import Image
from io import BytesIO
from nltk.tokenize import RegexpTokenizer
import nltk
from gensim.models import Word2Vec
from gensim.models import KeyedVectors
from nltk.corpus import stopwords
from sklearn.metrics.pairwise import cosine_similarity
import pandas as pd
from konlpy.tag import Twitter
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
from konlpy.tag import Okt

from tensorflow.keras.layers import Embedding, Dense, LSTM
from tensorflow.keras.models import Sequential
from tensorflow.keras.models import load_model
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint
from tensorflow.keras.models import load_model
import pickle as pk

twitter = Twitter()

abc = pd.read_csv("stopword.csv")
abcd = abc["아"].to_numpy()

stopword = np.append(abcd, np.array(["아"]))
stopword2 = ['의','가','이','은','들','는','좀','잘','걍','과','도','를','으로','자','에','와','한','하다']

def transform(text):
        li = list(text)
        return li



with open("tokenizer1_계정매핑_한자.txt","rb") as f:
    tokenizer = pk.load(f) 
with open("tokenizer2_계정매핑_한자.txt","rb") as f:
    tokenizer2 = pk.load(f) 

model = load_model("model_계정매핑_한자.h5")

### 이것으로 학습데이터를 추가적으로 만들기 위함
totaldata = pd.read_csv("전처리제거_다시.csv")
realdata = totaldata[8000:9000]

rawdata = pd.read_csv("coadata.csv")
data = rawdata.dropna(axis = 0)
data = data.drop_duplicates()
x_data = data["detailname"]
y_data = data["resultname"]

x_test = []
for i in x_data:
    x_test.append(transform(i))

word_index = tokenizer.word_index
x_test_key = tokenizer.texts_to_sequences(x_test)
x_test_key = pad_sequences(x_test_key, maxlen = 25)

vocab_size = len(tokenizer.word_index) + 1

y_test = np.argmax(model.predict(x_test_key, batch_size=32), axis = 1)
y_test = np.reshape(y_test, (-1,1)).tolist()
y_result = tokenizer2.sequences_to_texts(y_test)

plus = 0
minus = 0
for i in range(len(y_result)):
    
    if y_result[i] == y_data[i]:
        plus += 1
    else:
        minus += 1
    
print(plus)
print(minus)

#data = pd.DataFrame({"raw": x_test_raw, "y": y_data.reshape(-1)})

#data.to_csv("전처리제거후2.csv")
