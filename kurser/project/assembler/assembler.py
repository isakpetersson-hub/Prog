import os
import sys
import re


instructions = []

#00001_0001_001_0000000000

def translate(asm):
    asm_split = re.split(" |, |\(|\)", asm)
    args = []
    for i in range (len(asm_split)):
        if (asm_split[i] != ""):
            args.append(asm_split[i])
    #print args
    PM_instr = []
    OP = 0
    GRx = 0
    M = 0
    Addr = 0
    
    empty = "00000_0000_000_"
    value = 0
    
    print(args[0])
    print(args[0]=="cos")
    match args[0]:
        case "add": #add immediate
            if (len(args) != 3):
                return 0,0,0,0
            OP = "00100"
            GRx = convert_GR(int(args[1]))
            M = "001"
            Addr = "0000000000"
            value = convert_val(int(args[2]))
            val_instr = empty + value
            
            PM_instr = [OP, GRx, M, Addr]
            
            
            output = "_".join(PM_instr)
            instructions.append(output)
            instructions.append(val_instr)
        case "sub": #sub immediate
            if (len(args) != 3):
                return 0,0,0,0
            OP = "00101"
            GRx = convert_GR(int(args[1]))
            M = "001"
            Addr = "0000000000"
            value = convert_val(int(args[2]))
            val_instr = empty + value
            
            PM_instr = [OP, GRx, M, Addr]
            
            
            output = "_".join(PM_instr)
            instructions.append(output)
            instructions.append(val_instr)
        case "mult": #mult immediate
            if (len(args) != 3):
                return 0,0,0,0
            OP = "10000"
            GRx = convert_GR(int(args[1]))
            M = "001"
            Addr = "0000000000"
            value = convert_val(int(args[2]))
            val_instr = empty + value
            
            PM_instr = [OP, GRx, M, Addr]
            
            
            output = "_".join(PM_instr)
            instructions.append(output)
            instructions.append(val_instr)

            if (len(args) != 3):
                return 0,0,0,0
            OP = "10010"
            GRx = convert_GR(int(args[1]))
            M = "001"
            Addr = "0000000000"
            value = convert_val(int(args[2]))
            val_instr = empty + value
            
            PM_instr = [OP, GRx, M, Addr]
            
            
            output = "_".join(PM_instr)
            instructions.append(output)
            instructions.append(val_instr)
        case "dm_ldi": #Data Memory load immediate "ldi REG DM_Addr"
            if (len(args) != 3):
                return 0,0,0,0
            OP = "00010"
            GRx = convert_GR(int(args[1]))
            M = "001"
            Addr = "0000000000"
            value = convert_val(int(args[2]))
            val_instr = empty + value
            
            PM_instr = [OP, GRx, M, Addr]
            
            
            output = "_".join(PM_instr)
            instructions.append(output)
            instructions.append(val_instr)

        ###############################################################
        # Add special instructions for setting lines such as: "set_x0 GRx" which would just be "dm_sti GRx 1018"
        ###############################################################


        case "pm_ldi": #Program Memory load immediate "ldi REG DM_Addr"
            if (len(args) != 3):
                return 0,0,0,0
            OP = "00001"
            GRx = convert_GR(int(args[1]))
            M = "001"
            Addr = "0000000000"
            value = convert_val(int(args[2]))
            val_instr = empty + value
            
            PM_instr = [OP, GRx, M, Addr]
            
            
            output = "_".join(PM_instr)
            instructions.append(output)
            instructions.append(val_instr)    
        case "sti": #Data Memory store immediate "sti REG DM_Addr"
            if (len(args) != 3):
                return 0,0,0,0
            OP = "00011"
            GRx = convert_GR(int(args[1]))
            M = "000"
            Addr = convert_val(int(args[2]))
            
            PM_instr = [OP, GRx, M, Addr]
            
            
            output = "_".join(PM_instr)
            instructions.append(output)
        case "andi": #and immediate
            if (len(args) != 3):
                return 0,0,0,0
            OP = "00110"
            GRx = convert_GR(int(args[1]))
            M = "001"
            Addr = "0000000000"
            value = convert_val(int(args[2]))
            val_instr = empty + value
            
            PM_instr = [OP, GRx, M, Addr]
            
            
            output = "_".join(PM_instr)
            instructions.append(output)
            instructions.append(val_instr)
        case "ori": #or immediate
            if (len(args) != 3):
                return 0,0,0,0
            OP = "00111"
            GRx = convert_GR(int(args[1]))
            M = "001"
            Addr = "0000000000"
            value = convert_val(int(args[2]))
            val_instr = empty + value
            
            PM_instr = [OP, GRx, M, Addr]
            
            
            output = "_".join(PM_instr)
            instructions.append(output)
            instructions.append(val_instr)
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
        case "xori": #xor immediate
            if (len(args) != 3):
                return 0,0,0,0
            OP = "01000"
            GRx = convert_GR(int(args[1]))
            M = "001"
            Addr = "0000000000"
            value = convert_val(int(args[2]))
            val_instr = empty + value
            
            PM_instr = [OP, GRx, M, Addr]
            
            
            output = "_".join(PM_instr)
            instructions.append(output)
            instructions.append(val_instr)
        case "lsl": #lsl immediate
            if (len(args) != 3):
                return 0,0,0,0
            OP = "01010"
            GRx = convert_GR(int(args[1]))
            M = "000"
            Addr = convert_val(int(args[2]))
            
            PM_instr = [OP, GRx, M, Addr]
            
            
            output = "_".join(PM_instr)
            instructions.append(output)
        case "lsr": #lsr immediate
            if (len(args) != 3):
                return 0,0,0,0
            OP = "01011"
            GRx = convert_GR(int(args[1]))
            M = "000"
            Addr = convert_val(int(args[2]))
            
            PM_instr = [OP, GRx, M, Addr]
            
            
            output = "_".join(PM_instr)
            instructions.append(output)
        case "asr": #asr immediate
            if (len(args) != 3):
                return 0,0,0,0
            OP = "01100"
            GRx = convert_GR(int(args[1]))
            M = "000"
            Addr = convert_val(int(args[2]))
            
            PM_instr = [OP, GRx, M, Addr]
            
            
            output = "_".join(PM_instr)
            instructions.append(output)
        case "bra": #bra
            if (len(args) != 2):
                return 0,0,0,0
            OP = "01101"
            GRx = "0000"
            M = "000"
            Addr = convert_val(int(args[1]))
            
            PM_instr = [OP, GRx, M, Addr]
            
            
            output = "_".join(PM_instr)
            instructions.append(output)
        case "bne": #bne
            if (len(args) != 2):
                return 0,0,0,0
            OP = "01110"
            GRx = "0000"
            M = "000"
            Addr = convert_val(int(args[1]))
            
            PM_instr = [OP, GRx, M, Addr]
            
            
            output = "_".join(PM_instr)
            instructions.append(output)
        case "multi": #mult immediate
            if (len(args) != 3):
                return 0,0,0,0
            OP = "01111"
            GRx = convert_GR(int(args[1]))
            M = "001"
            Addr = "0000000000"
            value = convert_val(int(args[2]))
            val_instr = empty + value
            
            PM_instr = [OP, GRx, M, Addr]
            
            
            output = "_".join(PM_instr)
            instructions.append(output)
            instructions.append(val_instr)
        case "cos": #cos immediate
            print("är i cos nu")
            if (len(args) != 2):
                return 0,0,0,0
            OP = "10000"
            GRx = convert_GR(int(args[1]))
            M = "000"
            Addr = "0000000000"
            
            PM_instr = [OP, GRx, M, Addr]
            
            
            output = "_".join(PM_instr)
            instructions.append(output)
        case "sin": #cos immediate
            if (len(args) != 2):
                return 0,0,0,0
            OP = "10001"
            GRx = convert_GR(int(args[1]))
            M = "000"
            Addr = "0000000000"
            
            PM_instr = [OP, GRx, M, Addr]
            
            
            output = "_".join(PM_instr)
            instructions.append(output)

            
def convert_GR (val):
    return format(val, f'0{4}b')


def convert_val (val):
    return format(val, f'0{10}b')


def main():
    assembly = []
    script_dir = os.path.dirname(os.path.abspath(__file__))
    with open(os.path.join(script_dir, "assembly.txt"), "r") as f:
        assembly = [line.strip() for line in f]
        
    for i in assembly:
        translate(i);
    
    with open(os.path.join(script_dir, "output.txt"), "w") as f:
        for item in instructions:
            f.write(f'b"{item}",\n')
        f.write('others => b"00000_0000_000_0000000000"')


if __name__ == '__main__':
    main()