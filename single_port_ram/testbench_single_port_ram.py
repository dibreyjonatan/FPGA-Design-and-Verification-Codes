import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock
import logging
import random 
import collections
logging.basicConfig(level=logging.NOTSET)
logger=logging.getLogger()
logger.setLevel(logging.DEBUG)
predict_ram=collections.deque(maxlen=64)

@cocotb.test()
async def count_test(dut):
      global predict_ram
      cocotb.start_soon(Clock(dut.clk,10,'ns').start())
      

      for _ in range(5):   #wait for 20ns
            await RisingEdge(dut.clk)
      
       #Filling all the 64 memory cases with data 
      
      dut.we.value=1
      
      for i in range(64):
          value_load=random.randint(0,255)
          predict_ram.append(value_load) 
          dut.data.value=value_load
          dut.addr.value=i
          await RisingEdge(dut.clk)
      print(predict_ram)
      dut.we.value=0
      #doing the test by reading all the values stored in the ram
      for i in range(64):
          dut.addr.value=i
          await RisingEdge(dut.clk)
          actual_result=dut.q.value
          expected_result=predict_ram[(63+i)%64] 
          logger.info(f'TEST RESULT: {expected_result}={int(actual_result)}')
          assert expected_result==actual_result,"TEST FAILED"          





