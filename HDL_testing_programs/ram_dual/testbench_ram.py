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
      cocotb.start_soon(Clock(dut.read_clock,10,'ns').start())
      cocotb.start_soon(Clock(dut.write_clock,15,'ns').start())

      for _ in range(5):   #wait for 20ns
            await RisingEdge(dut.write_clock)
      
       #Filling all the 64 memory cases with data 
      
      dut.we.value=1
      
      for i in range(64):
          value_load=random.randint(0,255)
          predict_ram.append(value_load) 
          dut.data.value=value_load
          dut.write_addr.value=i
          await RisingEdge(dut.write_clock)
      print(predict_ram)
      dut.we.value=0
      #doing the test by reading all the values stored in the ram
      for i in range(64):
          dut.read_addr.value=i
          await RisingEdge(dut.read_clock)
          actual_result=dut.q.value
          expected_result=predict_ram[(i+63)%64] 
          logger.info(f'TEST RESULT: {expected_result}={int(actual_result)}')
          assert expected_result==actual_result,"TEST FAILED"          




