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

import re
import copy



with open("diction.txt","rb") as f:
    diction = pk.load(f) 

def split(word):
        selection = []
        li = re.split("[^a-zA-Z가-힣]", word)
        for i in li:
            word = wordmake(i)
            selection = selection + word.selection
        return selection


def makeword(word):
    for i in range(1,len(word)+1):
        if word[:i] in diction:
            diction[word[:i]] += 1
        else:
            diction[word[:i]] = 1
        makeword(word[i:])


class wordmake():
    
    def __init__(self, word):
        self.value = 0
        self.selection = []
        self.makeword2(word, [])
        
    def makeword2(self, word, arr):
    
        for i in range(2,len(word)+1):
        
            arr_copy = copy.copy(arr)
            arr_copy.append(word[:i])
            self.makeword2(word[i:], arr_copy)

        ## 순환문 바깥
        if len(word) == 0:
            # 확률계산
            val_tem = 1
            for i in arr:
                if i in diction:
                    val_tem = val_tem * diction[i]
                else:
                    val_tem = val_tem * 0.5
        
            if val_tem > self.value:
            
                self.selection = arr
                self.value = val_tem

            # 성공할 때만 확률집어넣기
                for i in arr:
                    if i in diction:
                        diction[i] += 1
                    else:
                        diction[i] = 1

class totalword():
    
    def __init__(self, word):
        
        self.selection = []
        
        li = split(word)



with open("tokenizer1_계정매핑_단어BS.txt","rb") as f:
    tokenizer = pk.load(f) 
with open("tokenizer2_계정매핑_단어BS.txt","rb") as f:
    tokenizer2 = pk.load(f) 

model = load_model("model_계정매핑_단어BS.h5")

word_index = tokenizer.word_index
vocab_size = len(tokenizer.word_index) + 1


def realtest(word):
    x_test = []
    for i in word:
        x_test.append(split(i))
    print(x_test)    
    x_test_key = tokenizer.texts_to_sequences(x_test)
    x_test_key = pad_sequences(x_test_key, maxlen = 10)
    y_test = np.argmax(model.predict(x_test_key, batch_size=32), axis = 1)
    y_test = np.reshape(y_test, (-1,1)).tolist()
    y_result = tokenizer2.sequences_to_texts(y_test)
    return y_result


    

#data = pd.DataFrame({"raw": x_test_raw, "y": y_data.reshape(-1)})

#data.to_csv("전처리제거후2.csv")
