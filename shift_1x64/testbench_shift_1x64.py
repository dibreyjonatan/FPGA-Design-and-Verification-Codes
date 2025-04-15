"""
This python code is written by : 
 _  __    _    __  __ ____    _      _____ _____ __________ ____   ___  
| |/ /   / \  |  \/  |  _ \  / \    |_   _| ____|__  / ____| __ ) / _ \ 
| ' /   / _ \ | |\/| | | | |/ _ \     | | |  _|   / /|  _| |  _ \| | | |
| . \  / ___ \| |  | | |_| / ___ \    | | | |___ / /_| |___| |_) | |_| |
|_|\_\/_/   \_\_|  |_|____/_/   \_\   |_| |_____/____|_____|____/ \___/ 


"""


import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock
import logging
import random 
import collections
logging.basicConfig(level=logging.NOTSET)
logger=logging.getLogger()
logger.setLevel(logging.DEBUG)
predict_register=collections.deque(maxlen=64)

def expectations(L,x):
     decale=L[0]
     for i in range(1,64):
          #L[64-i]=L[64-i-1]
          L[i-1]=L[i]   
     L[63]=x     
     print(L)
     return decale,L

@cocotb.test()
async def count_test(dut):
      global predict_register
      cocotb.start_soon(Clock(dut.clk,10,'ns').start())
      for _ in range(5):   #wait for 20ns
            await RisingEdge(dut.clk)
      
       #initialising the 64 bits of sr 
      
      dut.shift.value=1
      for _ in range(64):
          x=random.randint(0,1)
          predict_register.append(x) 
          dut.sr_in.value=x
          await RisingEdge(dut.clk)
      print(predict_register)
      dut.shift.value=0
      #to do the test properly by shifting the 64 bits
      for _ in range(64):
          dut.shift.value=1
          x=random.randint(0,1)
          dut.sr_in.value=x
          expected_value,predict_register=expectations(predict_register,x)
          #we need to keep an update of the predict_register as it is been shift 
          await RisingEdge(dut.clk)
          actual_result=dut.sr_out.value
          logger.info(f'TEST RESULT: {expected_value}={int(actual_result)}')
          assert expected_value==actual_result,"TEST FAILED"          



