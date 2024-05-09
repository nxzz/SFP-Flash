#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from os import environ
import sys
from pyftdi.i2c import I2cController
from time import sleep

class SFPModule(object):
    def __init__(self):
        self._i2c = I2cController()

    def open(self):
        url = environ.get('FTDI_DEVICE', 'ftdi://ftdi:232h/1')
        self._i2c.configure(url,frequency=400000)
        self._port = self._i2c.get_port(0x50)
        self._port51 = self._i2c.get_port(0x51)

    def close(self):
        pass

    def init(self):
        port = self._port51
        port.write_to(0x7B,0x0)
        port.write_to(0x7C,0x0)
        port.write_to(0x7D,0x0)
        port.write_to(0x7F,0x0)
    
    def write(self, bin):
        port = self._port
        print(len(bin))
        print(bin[0])
        for i in range(len(bin)):
            print(i,bin[i],bytes([bin[i]]))
            port.write_to(i, bytes([bin[i]]))
        
if __name__ == '__main__':
    sfp = SFPModule()
    sfp.open()
    sfp.init()
    f = open('patch.bin', 'rb')
    sfp.write(f.read())
    f.close()