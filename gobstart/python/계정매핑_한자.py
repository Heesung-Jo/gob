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

from tensorflow.keras.layers import Embedding, Dense, LSTM, Bidirectional,Dropout
from tensorflow.keras.models import Sequential
from tensorflow.keras.models import load_model
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint
from tensorflow.keras.utils import to_categorical
import pickle as pk

twitter = Twitter()

abc = pd.read_csv("stopword.csv")
abcd = abc["아"].to_numpy()

stopword = np.append(abcd, np.array(["아"]))
stopword2 = ['의','가','이','은','들','는','좀','잘','걍','과','도','를','으로','자','에','와','한','하다']


def transform(text):
        li = list(text)
        return li

rawdata = pd.read_csv("coadata.csv")
data = rawdata.dropna(axis = 0)
data = data.drop_duplicates()
x_data = data["detailname"]
y_data = data["resultname"]

'''
for i, text in enumerate(x_data):
    if i + 1 < len(x_data):
        x_data.iloc[i] = x_data.iloc[i] + x_data.iloc[i+1]
'''


x_test = []
for i in x_data:
    x_test.append(transform(i))

tokenizer = Tokenizer()
tokenizer.fit_on_texts(x_test)

word_index = tokenizer.word_index
x_test_key = tokenizer.texts_to_sequences(x_test)


temp = np.array(y_data)
y_test = np.reshape(temp, (-1, 1)).tolist()


tokenizer2 = Tokenizer()
tokenizer2.fit_on_texts(y_test)

word_index2 = tokenizer2.word_index
y_test_temp = tokenizer2.texts_to_sequences(y_test)
y_test_key = np.array(y_test_temp)
y_test_key = to_categorical(y_test_key)

maxval = max(len(l) for l in x_test_key)
meanval = sum(map(len, x_test_key))/len(x_test_key)

meanval_large = sum(len(l) for l in x_test_key if len(l) > meanval)/sum(1 for l in x_test_key if len(l) > meanval)

print(maxval)
print(meanval)
print(meanval_large)

x_test_key = pad_sequences(x_test_key, maxlen = 25)

vocab_size = len(tokenizer.word_index) + 1
embedding_dim = 100
hidden_units = 128

model = Sequential()
model.add(Embedding(vocab_size, embedding_dim))
model.add(Dropout(0.3))
model.add(Bidirectional(LSTM(hidden_units)))
model.add(Dropout(0.3))
model.add(Dense(98, activation='softmax'))

es = EarlyStopping(monitor='val_loss', mode='min', verbose=1, patience=4)
#mc = ModelCheckpoint('model2_양방향.h5', monitor='val_acc', mode='max', verbose=1, save_best_only=True)

model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['acc'])
history = model.fit(x_test_key, y_test_key, epochs=40, callbacks=[es], batch_size=128) #validation_split=0.2


model.save("model_계정매핑_한자.h5")

print("\n 테스트 정확도: %.4f" % (model.evaluate(x_test_key, y_test_key)[1]))

with open("tokenizer1_계정매핑_한자.txt","wb") as f:
    pk.dump(tokenizer, f)
with open("tokenizer2_계정매핑_한자.txt","wb") as f:
    pk.dump(tokenizer2, f)
