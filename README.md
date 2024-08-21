# variablechannel_cnn_fc
  A Verilog based CNN accelerator for binary 1-D signal classfication task
# Overview

![image](https://github.com/user-attachments/assets/b995c34b-1d2c-4fe8-b803-105cf22cd7aa) 

                            Abnormal


![image](https://github.com/user-attachments/assets/cc3e1323-51dc-4f36-a592-ed38c7c0437c) 

                            Normal


![image](https://github.com/user-attachments/assets/d7a10792-17c2-4cad-975a-e9e76eb7206d)

                            Process

# Structure

<img src = "https://github.com/user-attachments/assets/7de69c55-7eb3-4b64-bbd1-27ef89b8720a" alt = "Structure of the whole network" width = "500"/>

*Structure of Conv1*
<img alt="Structure of Conv1" src="https://github.com/user-attachments/assets/7178b4c6-27ce-4eb1-96ba-ee9d16207702" width = "500"/>


*Structure of Conv2*
<img alt = "Structure of Conv2" src = "https://github.com/user-attachments/assets/9b1ed052-bc20-4fcf-8193-412f1f115edb" width = "500"/>

# Content

variablechannel_cnn_fcc/
│
├── Source_1/
    │
    ├─ip(bram for fc1 and fc2)
    ├─ip1(bram for convnet2)
    ├─ip2(bram for convnet1)
    ├─new(code for fc)
    ├─new1(code for convnet2)
    ├─bew2(code for convnet1)
    

sim_1/
│
├─new/
   ├─tb.v(testbench of fc)
   ├─tb_all.v(testbench of cnn)

project-root/
│
├── src/
│   ├── main.py
│   ├── utils.py
│   └── config/
│       └── settings.yaml
│
├── tests/
│   └── test_main.py
│
├── README.md
└── requirements.txt


# Result
*16 channels*
<img alt="16 chnnels result" src="https://github.com/user-attachments/assets/4a3dd5f6-3a5b-4fbd-9ea2-7b458d3b45c2" width = "500"/>











