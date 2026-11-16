import cv2
import random
import numpy
from cvlib import *

def cvimg_to_list(img):
    '''Tar en bild(img) och gör om den till en lista av tuples som har värdena BGR'''
    pixels = []
    storlek = img.shape
    for x in range (storlek[0]):
        for y in range (storlek[1]):
            pixels.append(tuple(img[x,y])) 
    return pixels

def pixel_constraint(hlow, hhigh, slow, shigh, vlow, vhigh):
    '''Skaper en funkktion och tar input som fungerar som gränser'''
    def compare(hsv):
        '''Tar in värdet av en pixel och kollan om denns hsv är innom gränserna'''
        if  len(hsv) == 3:
            if hlow <= hsv[0] <= hhigh and slow <= hsv[1] <= shigh and vlow <= hsv[2] <= vhigh:
                return 1
            else:
                return 0
        else: 
            raise TypeError
    return compare
def generator_from_image(input_list):
    '''Skapar en funktion med en input lista''' 
    def generator(index):
        '''Tar ett värde och retunerar värdet på index från listan för det värdet'''
        if index < len(input_list):
            return input_list[index]
        else:
            raise IndexError
    return generator

def generator1(index):
    '''returnar en vit pixel om random.random blir 1 annars returnar den 0'''
    val = random.random() * 255 if random.random() > 0.99 else 0
    return (val, val, val)

def combine_images(hsv_list, condition, gen1, gen2):
    '''Sätter ihop 2 bilder med en gradiant'''
    try:
        img_list = []
        for i in range(len(hsv_list)):
            condition_value = condition(hsv_list[i])
            img_list.append(add_tuples(multiply_tuple(gen1(i),condition_value),multiply_tuple(gen2(i),(1 - condition_value))))
        return img_list
    except Exception as e:
        raise Exception(e)
def gradient_condition(rgb):
    '''returnar ett värde 0-1 beroende på pixeln som inputas'''
    return rgb[2]/255