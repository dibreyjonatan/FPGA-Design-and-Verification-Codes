import cocotb
import random
from cocotb.triggers import Timer

@cocotb.test()
async def andgate_test(dut):
    for _ in range(10):
            a=random.randint(0,1)
            b=random.randint(0,1)
            dut.a=a
            dut.b=b 
            print(f'a :{a}',end="")
            print(f'b:{b}')
            expected_value=a*b 
                                                                                                                                                                                                                                            
            await Timer(2,units='ns')
            output=dut.out
            print(f'output : {output}')
            assert expected_value==output,"FAILED TEST"
 
