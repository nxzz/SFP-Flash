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

    def close(self):
        pass

    def init(self):
        port = self._port
        # port.write([0x10,0x6A])		# Pres Average 512 / Temp Average 64
        # port.write([0x20,0xF4])		# ODR=25Hz、BDU=1
    
    def read(self):
        port = self._port
        return port.read_from(0x0,0x80)
        
if __name__ == '__main__':
    sfp = SFPModule()
    sfp.open()
    sfp.init()
    dump = sfp.read()
    f = open('dump.bin', 'wb')
    f.write(dump)
    print(dump)
    f.close()