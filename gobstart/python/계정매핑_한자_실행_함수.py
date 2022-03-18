# -*- coding: utf-8 -*-
"""
Created on Thu Oct 14 11:21:06 2021

@author: gocho
"""
import urllib.request
import pandas as pd
import numpy as np

from konlpy.tag import Twitter
from tensorflow.keras.preprocessing.sequence import pad_sequences
from tensorflow.keras.models import load_model
import pickle as pk




def transform(text):
        li = list(text)
        return li



with open("tokenizer1_계정매핑_한자.txt","rb") as f:
    tokenizer = pk.load(f) 
with open("tokenizer2_계정매핑_한자.txt","rb") as f:
    tokenizer2 = pk.load(f) 

model = load_model("model_계정매핑_한자.h5")

word_index = tokenizer.word_index
vocab_size = len(tokenizer.word_index) + 1


def realtest(word):
    x_test = []
    x_test.append(transform(word))
    x_test_key = tokenizer.texts_to_sequences(x_test)
    x_test_key = pad_sequences(x_test_key, maxlen = 25)
    y_test = np.argmax(model.predict(x_test_key, batch_size=32), axis = 1)
    y_test = np.reshape(y_test, (-1,1)).tolist()
    y_result = tokenizer2.sequences_to_texts(y_test)
    return y_result



#data = pd.DataFrame({"raw": x_test_raw, "y": y_data.reshape(-1)})

#data.to_csv("전처리제거후2.csv")
