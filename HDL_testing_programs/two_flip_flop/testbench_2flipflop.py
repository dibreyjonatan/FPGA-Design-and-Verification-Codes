import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock
import logging
import random 
import collections
logging.basicConfig(level=logging.NOTSET)
logger=logging.getLogger()
logger.setLevel(logging.DEBUG)
predict_register=collections.deque(maxlen=2)

def expectations(L,x):
     decale=L[0]
     L[0]=L[1]  
     L[1]=x     
     print(L)
     return decale,L

@cocotb.test()
async def count_test(dut):
      global predict_register
      cocotb.start_soon(Clock(dut.clk,10,'ns').start())
      
      for _ in range(5):   #wait for 20ns
            await RisingEdge(dut.clk)
      
       #initialising the two flip flop synchronizer
      dut.rst_n.value=0    
      await RisingEdge(dut.clk)
      expected_output=0
      actual_output=dut.q_o.value
      logger.info(f'TEST RESULT: {expected_output}={int(actual_output)}')
      assert expected_output==actual_output,"TEST FAILED"  
      dut.rst_n.value=1
      
      #preparing the predicted register
      for _ in range(2):
          predict_register.append(0)
          
      #testing the flipflop
      for _ in range(64):
          x=random.randint(0,1)
          dut.d_i.value=x
          expected_value,predict_register=expectations(predict_register,x)
          #we need to keep an update of the predict_register as it is been shift 
          await RisingEdge(dut.clk)
          actual_result=dut.q_o.value
          logger.info(f'TEST RESULT: {expected_value}={int(actual_result)}')
          assert expected_value==actual_result,"TEST FAILED"          




