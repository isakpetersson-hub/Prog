import math 
def new_board():
    board = {}
    return board
def is_free(board,x,y):
    if (x,y) in board:
        return False
    else:
        return True 
def place_piece(board,x,y,name):
    if is_free(board,x,y) == True:
        board[x,y] = name
        return True
    else:
        return False
def get_piece(board,x,y):
    if is_free(board,x,y) == False:
        return board[x,y]
    else:
        return False
def remove_piece(board,x,y):
    if is_free(board,x,y) == False:
        del board[x,y]
        return True
    else:
        return False
def move_piece(board,x,y,newx,newy):
    if is_free(board,x,y) == False and is_free(board,newx,newy == True):
        name = get_piece(board,x,y)
        remove_piece(board,x,y)
        place_piece(board,newx,newy,name)
        return True
    else:
        return False
def count (board,Type,value,name):
    count = 0
    if Type == "column":
        for key in board:
            if key[0] == value and get_piece(board,key[0],key[1]) == name:
                count += 1
        return count
    if Type == "row":
        for key in board:
            if key[1] == value and get_piece(board,key[0],key[1]) == name:
                count += 1
        return count
    else:
        return False
def nearest_piece(board,x,y):
    if len(board) > 0:
        first = list(board.keys())[0]
        distance = math.sqrt(((first[0] - x)**2) + ((first[1] - y)**2))
        closest = 0
        for key in board:
            if math.sqrt((key[0] - x)**2 + (key[1]-y)**2) < distance:
                distance = math.sqrt((key[0] - x)**2 + (key[1]-y)**2)
                closest = key
        return closest
    else:
        return False

def choose(n,k):
    if k > n-k:
        k = n-k
    return rec(n,k)
def rec(n,k):
    if k == 0:
        return 1
    else:
        return(n*rec(n-1,k-1)//k)