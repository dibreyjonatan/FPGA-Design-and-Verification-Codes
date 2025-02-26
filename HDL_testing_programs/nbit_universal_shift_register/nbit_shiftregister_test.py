import cocotb
from cocotb.triggers import RisingEdge,FallingEdge
from cocotb.clock import Clock
import logging
import random 

logging.basicConfig(level=logging.NOTSET)
logger=logging.getLogger()
logger.setLevel(logging.DEBUG)
predicted_count=0
output=0

def expectation_value(output,value,op):
      result=output
      if op==0 :
            result=output
      if op==1:
            result=value<<1 
      if op==2 :
            result=value>>1
             
      if op==3 :
            result=value 
      elif op>3:
            result=output              
      return result
def op_conversion(op):
     eq={
          0:"HOLD",
          1:"SHIFT_LEFT",
          2:"SHIFT_RIGHT",
          3:"SISO",
          4:"DEFAULT"
     }
     return (eq[op])

@cocotb.test()
async def count_test(dut):
      global output
      predicted_value=0
      cocotb.start_soon(Clock(dut.clk,10,'ns').start())
      dut.reset.value=1
      for _ in range(5):   #wait for 20ns
            await RisingEdge(dut.clk)
      dut.reset.value=0    
      actual_value=dut.data_out.value
      assert predicted_value==int(actual_value),"RESET TEST FAILED"
      logger.info(f'RESET TEST: {predicted_value}={int(actual_value)}')
      output=actual_value
      x=10
      #building a reset edge
      #cocotb.start_soon(Clock(dut.reset,45,'ns').start())
      while x>0 :
           value=random.randint(0,(2**16-1))
           op=random.randint(0,3)
           predicted_value=expectation_value(output,value,op)
           dut.data_in.value=value
           dut.control.value=op
           await RisingEdge(dut.clk) #or FallingEdge(dut.reset)
           actual_value=dut.data_out.value
           output=actual_value
           logger.info(f'{op_conversion(op)} TEST: Value to put in register {value} after test: prediction {predicted_value}= actual value from dut {int(actual_value)}')
           assert predicted_value==int(actual_value),f"{op_conversion(op)} TEST FAILED"
           
           x-=1

      """
      global predicted_count
      dut.reset.value=0
      cycle_test=0 # to test the values from 1-15 then breaking after
      while True :
            await RisingEdge(dut.clk)
            predicted_count+=1
            actual_count=dut.count.value
            assert predicted_count==int(actual_count), f"Failed test:the values are not thesame"
            if predicted_count==int(actual_count):
                  logger.info(f'PASSED : {predicted_count}={actual_count}')
            if cycle_test==1:
                 break 
            
            else:
                 logger.info(f"FAILED TEST for {predicted_count}={actual_count}")
                 break 
            if actual_count==15:
               predicted_count=0
               dut.reset.value=1   
               await RisingEdge(dut.clk)
               actual_count=dut.count.value
               print(f"the value after rest : {actual_count}")
               assert actual_count==predicted_count,"The reset failed"
               #après le test du button reset on met le reset à zero
               dut.reset.value=0       
               cycle_test=1
               """