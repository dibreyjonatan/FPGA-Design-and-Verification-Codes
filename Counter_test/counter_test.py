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
import logging

logging.basicConfig(level=logging.NOTSET)
logger=logging.getLogger()
logger.setLevel(logging.DEBUG)
predicted_count=0

@cocotb.test()
async def count_test(dut):
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
            """else:
                 logger.info(f"FAILED TEST for {predicted_count}={actual_count}")
                 break """
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
