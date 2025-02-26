import cocotb
import cocotb
from cocotb.triggers import RisingEdge
from cocotb.queue import QueueEmpty,Queue
from pyuvm import utility_classes
from cocotb.clock import Clock
import logging

logging.basicConfig(level=logging.NOTSET)
logger=logging.getLogger()
logger.setLevel(logging.DEBUG)


#python model of tiny two flipflop model
def expectations(L,x):
     decale=L[0]
     L[0]=L[1]  
     L[1]=x     
     print(L)
     return decale,L

class two_flipflopBfm(metaclass=utility_classes.Singleton) :
      def __init__(self) :
          self.dut=cocotb.top
          self.driver_queue=Queue(maxsize=0)
          self.cmd_queue=Queue(maxsize=0)
          self.result_queue=Queue(maxsize=0)
          #putting maxsize=1 means before it can put in queue , queue must be empty
          #putting maxsize of 0 means that the Queue is infinite ( see official doc)
          #the cmd and results queue are set to be infinite size 
          '''the driver is set to 1 as it is important to control the
           how the system works with the simulator'''
          
      async def send_data(self,x):
          await self.driver_queue.put(x)
      async def get_cmd(self):
          cmd=await self.cmd_queue.get()
          return cmd    
      async def get_result(self):
          result= await self.result_queue.get()
      
      #reset function 
      async def reset(self):
          self.dut.rst_n.value=0   
          self.dut.d_i.value=0 
          await RisingEdge(self.dut.clk) 
          print("i have been executed") 
          print(self.dut.q_o.value)     
          self.dut.rst_n.value=1
          await RisingEdge(self.dut.clk) 
          print("i have been executed") 
          print(self.dut.q_o.value)
      #driver function
      async def driver_bfm(self):
          self.dut.d_i.value=0
          while True :
             await RisingEdge(self.dut.clk)
             try:
                data=self.driver_queue.get_nowait()
                self.dut.d_i.value=data
                print(f"data :{data}")
             except QueueEmpty:
                pass
      #cmd_bfm 
      #it role is to send the input value to the monitor that will send it to the scoreboard
      async def cmd_bfm(self):
          while True :
              await RisingEdge(self.dut.clk)
              cmd=self.dut.d_i.value 
              print(f"cmd:{cmd}")
              self.cmd_queue.put_nowait(cmd) 
               
      async def result_bfm(self):
          while True :
              await RisingEdge(self.dut.clk)
              result=self.dut.q_o.value
              print(f"result:{result}")
              self.result_queue.put_nowait(result)
              
      def start_bfm(self):
          cocotb.start_soon(self.driver_bfm())
          cocotb.start_soon(self.cmd_bfm())
          cocotb.start_soon(self.result_bfm()) 
           
      def start_clock_bfm(self):
          self.result_queue.put_nowait(0)
          cocotb.start_soon(Clock(self.dut.clk,10,'ns').start())     
 
