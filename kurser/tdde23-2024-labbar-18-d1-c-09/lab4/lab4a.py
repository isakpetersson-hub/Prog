import string
def split_rec(text):
    if not text:
        return "", ""

    lower, upper = split_rec(text[1:])

    letter = text[0]

    if letter in string.ascii_lowercase or letter == "å" or letter == "ä" or letter == "ö" or letter == "_" or letter == ".":
        lower = letter + lower
    if letter in string.ascii_uppercase or letter == "Å" or letter == "Ä" or letter == "Ö" or letter == " " or letter == "|":
        upper = letter + upper
    return lower, upper 

def split_it(text):
    lower = ""
    upper = ""
    for letter in text:
        if letter in string.ascii_lowercase or letter == "å" or letter == "ä" or letter == "ö" or letter == "_" or letter == ".":
            lower += letter
        if letter in string.ascii_uppercase or letter == "Å" or letter == "Ä" or letter == "Ö" or letter == " " or letter == "|":
            upper += letter
    return(lower, upper)

first,second = split_it("")
print(first,second)