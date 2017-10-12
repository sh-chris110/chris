#!/usr/bin/python
from multiprocessing import Process, Manager, Lock
import serial
import os
import time

class IMU(object):
    def __init__(self):
        self.accx = 0.0;
        self.accy = 0.0;
        self.accz = 0.0;
  
        self.magx = 0.0;
        self.magy = 0.0;
        self.magz = 0.0;

        self.gyrox = 0.0;
        self.gyroy = 0.0;
        self.gyroz = 0.0;

    def __del__(self):
        pass

class IMU_Driver(object):
    def __init__(self):
        self.imu_raw_data = IMU();
        self.com = serial.Serial('/dev/ttyACM0', 19200, timeout=1);
        pass

    def read_imu(self):
        while True:
            line = self.com.readline().strip(); 
            values = line.split(",");
            if len(values) != 10:
                continue;
            
            time = values[0].strip();

            self.imu_raw_data.accx = float(values[1].strip());
            self.imu_raw_data.accy = float(values[2].strip());
            self.imu_raw_data.accz = float(values[3].strip());
            
            self.imu_raw_data.gyrox = float(values[4].strip());
            self.imu_raw_data.gyroy = float(values[5].strip());
            self.imu_raw_data.gyroz = float(values[6].strip());

            self.imu_raw_data.magx = float(values[7].strip());
            self.imu_raw_data.magy = float(values[8].strip());
            self.imu_raw_data.magz = float(values[9].strip());
            
            return self.imu_raw_data;

    def cal(self):
        pass
    
    def __del__(self):
        pass
    
class opengl_process(Process):
    imu = None;
    imu_lock = None;
    def __init__(self, imu, imu_lock):
        Process.__init__(self)  
        self.imu = imu;
        self.imu_lock = imu_lock;
        pass

    def run(self): 
        while True: 
            print "openGL process is running";
            time.sleep(1);

    def __del__(self):
        pass

class mahony_process(Process, IMU_Driver):
    imu = None;
    imu_lock = None;
    def __init__(self, imu, imu_lock):
        Process.__init__(self)  
        IMU_Driver.__init__(self)
        self.imu = imu;
        self.imu_lock = imu_lock;
        pass

    def run(self): 
        pass

    def __del__(self):
        pass


class madgwick_process(Process, IMU_Driver):
    imu = None;
    imu_lock = None;
    def __init__(self, imu, imu_lock):
        Process.__init__(self)  
        IMU_Driver.__init__(self)
        self.imu = imu;
        self.imu_lock = imu_lock;
        pass

    def run(self): 
        while True:
            raw_data = self.read_imu(); 
            print raw_data.gyroz

    def __del__(self):
        pass

if __name__ == '__main__':
    threads = [] # all the thread need to be add to this list  
    
    imu_lock = Lock();
    mgr = Manager();
    imu = mgr.Namespace();
    
    imu.q0 = 0.0;
    imu.q1 = 0.0;
    imu.q2 = 0.0;
    imu.q3 = 0.0;

    imu.ax = 0.0
    imu.ay = 0.0
    imu.az = 0.0

    imu.vx = 0.0
    imu.vy = 0.0
    imu.vz = 0.0
    
    gl = opengl_process(imu, imu_lock);
    gl.start(); 

    imu_fusion = madgwick_process(imu, imu_lock);
    imu_fusion.start();

    #p.is_alive()
    #p.terminate()
    gl.join();
    imu_fusion.join();
    
