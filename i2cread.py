#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from os import environ
import sys
from pyftdi.ftdi import Ftdi
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
        port = self._port

    def read(self):
        port = self._port
        return port.read_from(0x0,0x80)

    def readtunable(self):
        port = self._port51
        port.write_to(0x7F,[0x2])
        return port.read_from(0x0,0x100)


if __name__ == '__main__':
    print(Ftdi.show_devices())
    sfp = SFPModule()
    sfp.open()
    sfp.init()
    dump = sfp.read()
    f = open('dump.bin', 'wb')
    f.write(dump)
    f.close()

    # dump2 = sfp.readtunable()
    # f2 = open('dump_tunable.bin', 'wb')
    # f2.write(dump2)
    # f2.close()