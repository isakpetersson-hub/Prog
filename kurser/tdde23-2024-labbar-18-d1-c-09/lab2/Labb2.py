def check_pnr(useranswer):
    useranswer = str(useranswer)
    converted = conver_to_list(useranswer)
    summa = siffersumma(converted)
    last_num = closest_ten(summa)
    if last_num == converted[-1]:
        return True
    else:
        return False
def conver_to_list(useranswer):
    useranswer = useranswer[1:-1]
    useranswer = useranswer.split(", ") 
    useranswer = [eval(i) for i in useranswer]
    return(useranswer)
def siffersumma(base_list):
    summa = 0
    length = len(base_list)
    for i in range(length-1):
        if i % 2 == 0:
            temp =  base_list[i] * 2
            summa += temp % 10 
            summa += temp // 10
        else:
            summa += base_list[i]
    return summa
def closest_ten(summa):
    sista_num = 0
    while(summa % 10 != 0):
        sista_num += 1
        summa += 1
    return sista_num