# +--------------------+
# | ASSEMBLER 2        |
# +--------------------+
import os
import sys
import re

# Instrunction idx|dir|ime GRx 

instructions = []
labels_addr = {}
addr_counter = -1

#00001_0001_001_0000000000

def translate(asm):
    asm = asm.split("#")[0].strip() # remove comments
    if not asm: return
    global addr_counter
    special_instructions = ["not", "bra", "bne", "set_x0","set_y0","set_x1","set_y1", "set_col", "is_busy", "is_new_frame", "get_keyboard"]
    asm_split = re.split(" |, |\(|\)", asm)
    args = []
    for i in range (len(asm_split)):
        if (asm_split[i] != ""):
            args.append(asm_split[i])

    # args
    PM_instr = []
    OP = 0
    GRx = 0
    M = 0
    Addr = 0
    
    if addr_counter > 1022:
        raise ValueError(f"Too Many Instructions Lines")

    value = "00000_0000_000_00000000000"
    
    if args[0][0] == "@": # Labels
        print("\n" + " ".join(args).ljust(24) + " ->  " + args[0])
        labels_addr[args[0]] = addr_counter + 1

    elif args[0] in special_instructions: 
        match args[0]:
            # not GRx
            case "not": #not "not REG"
                if (len(args) != 2):
                    return 0,0,0,0
                OP = "01001"
                GRx = convert_GR(int(args[1]))
                M = "000"
                Addr = "0000000000"

                PM_instr = [OP, GRx, M, Addr]
                output = "_".join(PM_instr)
                instructions.append(output)
                addr_counter += 1


            # bra @label
            case "bra": #bra
                if (len(args) != 2):
                    return 0,0,0,0
                OP = "01101"
                GRx = "0000"
                M = "000"
                #Addr = convert_addr(int(labels_addr[args[1]]))
                Addr = args[1]

                PM_instr = [OP, GRx, M, Addr]
                output = "_".join(PM_instr)
                instructions.append(output)
                addr_counter += 1

            # bne @label
            case "bne": #bne
                if (len(args) != 2):
                    return 0,0,0,0
                OP = "01110"
                GRx = "0000"
                M = "000"
                #Addr = convert_addr(int(labels_addr[args[1]]))
                Addr = args[1]

                PM_instr = [OP, GRx, M, Addr]
                output = "_".join(PM_instr)
                instructions.append(output)
                addr_counter += 1

        # Store aliases for interacting with the Line Engine
        if (args[0] == "set_x0" or args[0] == "set_y0" or args[0] == "set_x1" or args[0] == "set_y1" or args[0] == "set_col"):

            if (len(args) != 2):
                return 0,0,0,0
            OP = "00011"
            GRx = convert_GR(int(args[1]))
            M = "000"
            match args[0]:
                case "set_x0":
                    Addr = "1111101001" #x0 DM mapping
                case "set_y0":
                    Addr = "1111101010" #y0 DM mapping
                case "set_x1":
                    Addr = "1111101011" #x1 DM mapping
                case "set_y1":
                    Addr = "1111101100" #y1 DM mapping
                case "set_col":
                    Addr = "1111101101" #col DM mapping

            PM_instr = [OP, GRx, M, Addr]
            output = "_".join(PM_instr)
            instructions.append(output)
            addr_counter += 1   

        # Load Aliases for getting info from Line Engine & Keyboard
        elif (args[0] == "is_busy" or args[0] == "is_new_frame" or args[0] == "get_keyboard"):
            if (len(args) != 2):
                return 0,0,0,0
            OP = "00010"
            GRx = convert_GR(int(args[1]))
            M = "000"
            match args[0]:
                case "is_busy":
                    Addr = "1111101110" #busy DM mapping
                case "is_new_frame":
                    Addr = "1111101111" #new_frame DM mapping
                case "get_keyboard":
                    Addr = "1111110010" #KDR DM mapping

            PM_instr = [OP, GRx, M, Addr]
            output = "_".join(PM_instr)
            instructions.append(output)
            addr_counter += 1 

    else: # Standard instructions with 4 arguments
        if (len(args) != 4):
            return 0,0,0,0

        match args[0]:
            case "load_pm":
                OP = "00001"
            case "load_dm":
                OP = "00010"
            case "store":
                OP = "00011"
            case "add":
                if args[1] == "ime":
                    OP = "00100"
                else:
                    OP = "10100"
            case "sub":
                if args[1] == "ime":
                    OP = "00101"
                else:
                    OP = "10101"
            case "and":
                if args[1] == "ime":
                    OP = "00110"
                else:
                    OP = "10110"
            case "or":
                if args[1] == "ime":
                    OP = "00111"
                else:
                    OP = "10111"
            case "xor":
                if args[1] == "ime":
                    OP = "01000"
                else:
                    OP = "11000"
            case "not":
                OP = "01001"
            case "lsl":
                OP = "01010"
            case "lsr":
                OP = "01011"
            case "asr":
                OP = "01100"
            case "bra":
                OP = "01101"
            case "bne":
                OP = "01110"
            case "mult":
                OP = "01111"
            case "cos":
                OP = "10000"
            case "sin":
                OP = "10001"
            case "halt":
                OP = "10010"
            case "cmp":
                OP = "10011"
            case _:
                raise ValueError(f"Unknown instruction: {args[0]}")

        M = convert_M(args[1])
        GRx = convert_GR(int(args[2]))
        if (args[1] == "ime"): # using the address field or not
            Addr = "0000000000"
            value = convert_val(int(args[3]))
        else:
            Addr = convert_addr(int(args[3]))

        PM_instr = [OP, GRx, M, Addr]

        output = "_".join(PM_instr)
        instructions.append(output)
        addr_counter += 1
        if (args[1] == "ime"): # using the address field or not
            instructions.append(value)
            addr_counter += 1
    
    # python print master type shit:
    if (len(args) > 1):
        if(args[1] == "ime"):
            print(" ".join(args).ljust(24) + " ->  " + "0x" + str(hex(addr_counter - int(args[1] == "ime"))[2:].zfill(4)) + ": " + "_".join(PM_instr))
            print(" ".ljust(24) + " ->  " + "0x" + str(hex(addr_counter)[2:].zfill(4)) + ": " + value)
        else:
            print(" ".join(args).ljust(24) + " ->  " + "0x" + str(hex(addr_counter)[2:].zfill(4)) + ": " + "_".join(PM_instr))

def convert_M (val):
    match val:
        case "dir": # Direct
            return "000"
        case "ime": # Immediate
            return "001"
        case "indp": # Indirect PM
            return "010"
        case "indd": # Indirect DM
            return "011"
        case "idx": # Indexed
            return "100"

def convert_GR (val):
    return format(val, f'0{4}b')

def convert_addr (val):
    return format(val, f'0{10}b')

def convert_val (val):
    binary_str = to_twos_complement(val)
    return f"{binary_str[0:5]}_{binary_str[5:9]}_{binary_str[9:12]}_{binary_str[12:]}"

def to_twos_complement(value, bits=22):
    if value < 0:
        value = (1 << bits) + value
    return format(value, f'0{bits}b')

def main():
    assembly = []
    script_dir = os.path.dirname(os.path.abspath(__file__))
    with open(os.path.join(script_dir, "assembly.asm"), "r") as f:
        assembly = [line.strip() for line in f]
    
    addr_counter = 0

    for i in assembly:
        translate(i);

    for i in range(len(instructions)):
        if "@" in instructions[i]:
            instructions[i] = str(instructions[i].split("@")[0]) + convert_addr(labels_addr["@" + instructions[i].split("@")[1]])
    
    with open(os.path.join(script_dir, "output.txt"), "w") as f:
        for item in instructions:
            f.write(f'b"{item}",\n')
        f.write('others => b"00000_0000_000_0000000000"')

    with open(os.path.join(script_dir, "output.o"), "wb") as f:
        for item in instructions:
            bits = "".join(item.split("_"))            # 22 bits, MSB-first
            v = int(bits, 2)                           # the integer value
            f.write(bytes([
                v        & 0xFF,                       # byte 0: bits 7..0
                (v >> 8)  & 0xFF,                       # byte 1: bits 15..8
                (v >> 16) & 0x3F,                       # byte 2: bits 21..16
            ]))
        f.write(b'\x00' * 3 * 16)




if __name__ == '__main__':
    main()