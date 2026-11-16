import cv2
import math
from cvlib import *
def cvimg_to_list(img):
    '''Tar en bild(img) och gör om den till en lista av tuples som har värdena BGR'''
    pixels = []
    storlek = img.shape
    for x in range (storlek[0]):
        for y in range (storlek[1]):
            pixels.append(tuple(img[x,y])) 
    return pixels

def unsharp_mask(x):
    '''Tar ett värde x och retunerar en mask som skärper upp en bild'''
    start = -(x//2)
    end = ((x-1)//2)
    index_number = range(start,end+1)
    gausisk_blur = []
    bas = -(1/(2 * math.pi * 4.5**2))
    for i in index_number:
        col = []
        for j in index_number:
            if i == 0 and j == 0:
                value = 1.5
            else:
                value = bas*math.e** -((i**2 + j**2) / (2 * 4.5**2))
            col.append(value)
        gausisk_blur.append(col)
    print(gausisk_blur)
    return(gausisk_blur)

unsharp_mask(3)