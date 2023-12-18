import subprocess
import sys
import os

contract_path = "./test_case"
contract_rela_path = "test_case"

syn_lines = []

for folder in os.listdir(contract_path):

    if folder == "selected":
        continue

    cur_path = contract_path + "/" + folder
    cur_rela_path = contract_rela_path + "/" + folder

    if not os.path.isdir(cur_path):
        continue

    for x in os.listdir(cur_path):
        # print(x)
        c_path = cur_path + "/" + x  
        c_rela_path = cur_rela_path + "/" + x  
        
        syn_contract_path = c_rela_path + "/synthesized.sol"

        print(x)

        
        
        with open(syn_contract_path, 'r', encoding='utf-8') as ifile:
            lines = ifile.readlines()
            cur_line = len(lines)
            print(cur_line)
            syn_lines.append(cur_line)

print(sum(syn_lines) / len(syn_lines))
        

# python batch_Deckard.py > test_case/batch_similarity.txt