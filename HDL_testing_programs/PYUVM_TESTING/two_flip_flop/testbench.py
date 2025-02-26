import cocotb
from pyuvm import *
import random
import pyuvm
from utils import two_flipflopBfm,expectations 
import collections
predict_register=collections.deque(maxlen=2)

import logging

logging.basicConfig(level=logging.NOTSET)
logger=logging.getLogger()
logger.setLevel(logging.DEBUG)
#initialising register
for _ in range(2):
   predict_register.append(0)
   
#Sequence classes

class flipflopItem(uvm_sequence_item):
     def __init__(self,name,x):
         super().__init__(name)
         self.data=x
     def randomize_operands(self):
         self.data=random.randint(0,1)
     def randomize(self):
         self.randomize_operands()
     def __eq__(self,other):
         same=self.data==self.other
         return same
     def __str__(self):
         return f'{self.get_name()}: data : {self.data}'

class RandomSeq(uvm_sequence):
     async def body(self):
         cmd_tr=flipflopItem("cmd_tr",0)
         await self.start_item(cmd_tr)
         await self.finish_item(cmd_tr)

class TestAllSeq(uvm_sequence):
     async def body(self):
         seqr=ConfigDB().get(None,"","SEQR")
         data=RandomSeq("random")
         await data.start(seqr)
         
#writing the driver class
class Driver(uvm_driver):
     def build_phase(self):
         self.ap=uvm_analysis_port("ap",self)
     def start_of_simulation_phase(self):
         self.bfm=two_flipflopBfm()
     async def launch_tb(self):
         self.bfm.start_clock_bfm()
         await self.bfm.reset()
         self.bfm.start_bfm()
         
     async def run_phase(self):
         await self.launch_tb()
       
         while True :
             cmd=await self.seq_item_port.get_next_item()
             print(f"cmd driver :{cmd.data}")
             await self.bfm.send_data(cmd.data)
             result = await self.bfm.get_result()
            
             self.ap.write(result) 
             print(f"driver result : {result}") 
             cmd.result=result
             self.seq_item_port.item_done()
                 
             
             
class Coverage(uvm_subscriber):
     def end_of_elaboration_phase(self):
         self.cvg=set()
     def write(self,cmd):
         self.cvg.add(2+cmd) #since hash doesnot exist for binary values 
     def report_phase(self):
         try:
             disable_errors=ConfigDB().get(self,"","DISABLE_COVERAGE_ERRORS")
         except UVMConfigItemNotFound:
             disable_errors=False
         if not disable_errors :
            if  not len(self.cvg) :
                self.logger.error(f"Functional coverage error")
                assert False
            else :
                self.logger.info("Covered all operations")
                assert True         

class Scoreboard(uvm_component):
    def build_phase(self):
        self.cmd_fifo=uvm_tlm_analysis_fifo("cmd_fifo",self)
        self.result_fifo=uvm_tlm_analysis_fifo("result_fifo",self)
        self.cmd_get_port=uvm_get_port("cmd_get_port",self)
        self.result_get_port=uvm_get_port("result_get_port",self)
        self.cmd_export=self.cmd_fifo.analysis_export 
        self.result_export=self.result_fifo.analysis_export
    def connect_phase(self):
        self.cmd_get_port.connect(self.cmd_fifo.get_export)
        self.result_get_port.connect(self.result_fifo.get_export)
    def check_phase (self):
        global predict_register
        passed=True 
        try :
           self.errors=ConfigDB().get(self,"","CREATE_ERRORS")
        except UVMConfigItemNotFound:
           self.errors=False
        while self.result_get_port.can_get() :
           _,actual_result=self.result_get_port.try_get()
           cmd_success,cmd=self.cmd_get_port.try_get()
           
           if not cmd_success:
              logger.critical(f"result { actual_result} had no command")
           else :
              predicted_result,predict_register=expectations(predict_register,cmd)
              if predicted_result== actual_result :
                 logger.info(f"PASSED {predicted_result}={actual_result}")
              else :
                 print(predict_register)
                 print(f"FAILED {predicted_result}={actual_result}")        
                 passed=False
                                                                
        assert passed
        
class Monitor(uvm_component):
    def __init__(self,name,parent,method_name):
       super().__init__(name,parent)
       self.method_name=method_name
       
    def build_phase(self):
       self.ap=uvm_analysis_port("ap",self)
       self.bfm=two_flipflopBfm()
       self.get_method=getattr(self.bfm,self.method_name)
    async def run_phase(self):
       while True :
           datum= await self.get_method()
           self.logger.debug(f"MONITORED {datum}")
           self.ap.write(datum)
                                
                               
class FlipFlopEnv(uvm_env):
    def build_phase(self):
        self.seqr=uvm_sequencer("seqr",self)
        ConfigDB().set(None,"*","SEQR",self.seqr)
        self.driver=Driver.create("driver",self)
        self.cmd_mon=Monitor("cmd_mon",self,"get_cmd")
        self.coverage=Coverage("coverage",self)
        self.scoreboard=Scoreboard("scoreboard",self)
    def connect_phase(self):
        self.driver.seq_item_port.connect(self.seqr.seq_item_export)
        self.cmd_mon.ap.connect(self.scoreboard.cmd_export)
        self.cmd_mon.ap.connect(self.coverage.analysis_export)
        self.driver.ap.connect(self.scoreboard.result_export)
        
@pyuvm.test()
class FlipFlop_Test(uvm_test):
      def build_phase(self):
          self.env=FlipFlopEnv("env",self)
      def end_of_elaboration_phase(self):
          self.test_all=TestAllSeq.create("test_all")
      async def run_phase(self):
          self.raise_objection()
          await self.test_all.start()
          self.drop_objection()
'''                                                                                     
@pyuvm.test(expect_fail=True)
class TestErrors(FlipFlop_Test):
      def start_of_simulation_phase(self):
          ConfigDB().set(None,"*","CREATE_ERRORS",True)
'''                                                                                        
