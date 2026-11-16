def interpret(uttryck,tolkning):
    for item in uttryck:
        if item in tolkning:
            uttryck = tolkning[uttryck]
    print(uttrck)

interpret(["door_open", "AND", "cat_gone"], {"door_open" : "false", "cat_gone" : "true", "cat_asleep" : "true"} )
    