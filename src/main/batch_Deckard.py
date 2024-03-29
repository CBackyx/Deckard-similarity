import subprocess
import sys
import os

contract_path = "./test_case"
contract_rela_path = "test_case"

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
        
        cmd = ['python3', 
                "calSolVecSimilarity.py",
                c_rela_path + "/ground_truth_proofread.sol",
                c_rela_path + "/synthesized.sol"
                ]
        process = subprocess.Popen(cmd, stdout=subprocess.PIPE)
        process.wait()
        print(x)
        # print(dirNamePatterns[i] + testcase_Dirs[i][j])
        print(process.stdout.read().decode('utf-8'))

# python3 batch_Deckard.py > test_case/batch_similarity.txt