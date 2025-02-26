import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
import logging
import random

logging.basicConfig(level=logging.NOTSET)
logger=logging.getLogger()
logger.setLevel(logging.DEBUG)
predicted_count=0

@cocotb.test()
async def count_test(dut):
      global predicted_count
      cocotb.start_soon(Clock(dut.clk,10,'ns').start())
      dut.reset.value=1
      for _ in range(2):   #wait for 20ns
            await RisingEdge(dut.clk)
      dut.reset.value=0      
      cycle=20
      while cycle >0 :
            pos=10
            for _ in range(pos):
                  predicted_count+=1
                  dut.up.value=1
                  await RisingEdge(dut.clk)
                  expected_value=dut.count.value

                  logger.info(f'RESULT: {predicted_count}={expected_value}')
                  
                  dut.up.value=0
                  assert predicted_count==int(expected_value) ,"TEST FAILED"

            for _ in range(pos//4):
                  predicted_count-=1
                  dut.down.value=1
                  await RisingEdge(dut.clk)
                  expected_value=dut.count.value
                  logger.info(f'RESULT: {predicted_count}={expected_value}')
                  dut.down.value=0
                  assert predicted_count==int(expected_value),"TEST FAILED"
            
                  if predicted_count<0 or predicted_count>15 :
                     predicted_count=0 
            #test on the reset button
            cycle-=1
            if cycle ==4 :
                  dut.reset.value=1
                  predicted_count=0
                  await RisingEdge(dut.clk)
                  expected_value=int(dut.count.value)
                  dut.reset.value=0
                  logger.info(f'RESULT : {predicted_count}={expected_value}')
                  assert predicted_count==expected_value,"TEST FAILED"
            

                  
      