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
     sr_out=L[0]
     sr_tap_one=L[48] #63-15 
     sr_tap_two=L[32] #63-31
     sr_tap_three=L[16] #63-47
     
     for i in range(1,64):
          #L[64-i]=L[64-i-1]
          L[i-1]=L[i]   
     L[63]=x     
     print(L)
     return sr_out,sr_tap_one,sr_tap_two,sr_tap_three,L

@cocotb.test()
async def count_test(dut):
      global predict_register
      cocotb.start_soon(Clock(dut.clk,10,'ns').start())
      for _ in range(5):   #wait for 20ns
            await RisingEdge(dut.clk)
      
       #initialising the 64 bits of sr 
      
      dut.shift.value=1
      for _ in range(64):
          x=random.randint(0,255)
          predict_register.append(x)
          dut.sr_in.value=x
          await RisingEdge(dut.clk)
      print(predict_register)
      dut.shift.value=0
      #to do the test properly by shifting the 64 bits
      for _ in range(64):
          dut.shift.value=1
          x=random.randint(0,255)
          dut.sr_in.value=x
          a,b,c,d,predict_register=expectations(predict_register,x)
          expected_sr_out=a
          expected_sr_tap_one=b
          expected_sr_tap_two=c
          expected_sr_tap_three=d
          #we need to keep an update of the predict_register as it is been shift 
          await RisingEdge(dut.clk)
          actual_result_sr_out=dut.sr_out.value
          actual_result_sr_tap_one=dut.sr_tap_one.value
          actual_result_sr_tap_two=dut.sr_tap_two.value
          actual_result_sr_tap_three=dut.sr_tap_three.value
          logger.info(f'TEST RESULT: {expected_sr_out}={int(actual_result_sr_out)}')
          logger.info(f'TEST RESULT: {expected_sr_tap_one}={int(actual_result_sr_tap_one)}')
          logger.info(f'TEST RESULT: {expected_sr_tap_two}={int(actual_result_sr_tap_two)}')
          logger.info(f'TEST RESULT: {expected_sr_tap_three}={int(actual_result_sr_tap_three)}')
          
          assert expected_sr_out==actual_result_sr_out,"TEST FAILED" 
          assert expected_sr_tap_one==actual_result_sr_tap_one,"TEST FAILED" 
          assert expected_sr_tap_two==actual_result_sr_tap_two,"TEST FAILED"
          assert expected_sr_tap_three==actual_result_sr_tap_three,"TEST FAILED"
            
              
          
               




