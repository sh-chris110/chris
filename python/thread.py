#!/usr/bin/python
from multiprocessing import Process, Manager, Lock ,RLock
import os
import time
from multiprocessing.managers import BaseManager

class IMU():
    q0 = 0;
    q1 = 0;
    q2 = 0;
    q3 = 0;

    ax = 0;
    ay = 0;
    az = 0;

    vx = 0;
    vy = 0;
    vz = 0;
    
    def __init__(self):
        pass

    def set(self, key, value):
        try:
            setattr(self, key, value);
        except:
            pass

    def get(self, key):
        try:
            return getattr(self, key);
        except:
            pass

    def __setitem__(self, key, value):
        self.set(key, value)

    def __del__(self):
        pass 

class opengl_process(Process):
    manager = None;
    lock = None;
    def __init__(self, manager, lock):
        Process.__init__(self)  
        self.manager = manager;
        self.lock = lock;
        pass

    def run(self): 
        while True: 
            print "hahahaha";
            time.sleep(1);

    def __del__(self):
        pass

class mahony_process(Process):
    manager = None;
    lock = None;
    def __init__(self, manager, lock):
        Process.__init__(self)  
        self.manager = manager;
        self.lock = lock;
        pass

    def run(self): 
        self.manager.set("q0", 1);
        print self.manager.get("q0");
        pass

    def __del__(self):
        pass


class madgwick_process(Process):
    manager = None;
    lock = None;
    def __init__(self, manager, lock):
        Process.__init__(self)  
        self.manager = manager;
        self.lock = lock;
        pass

    def run(self): 
        while True:
            print self.manager.get("q0");
            time.sleep(1);

    def __del__(self):
        pass

if __name__ == '__main__':
    threads = [] # all the thread need to be add to this list  
    imu = IMU();
    BaseManager.register("IMU", imu);
    IMUManager = BaseManager();
    IMUManager.start();
    manager = IMUManager.IMU();
    #manager = IMU();
    #manager.q0 =1;
    #manager.set("q0" ,1);
    #print manager.get("q0");
    #print manager.q0

    #lock = Lock();

    #gl = opengl_process(manager, lock);
    #gl.start(); 

    #imu_fusion = madgwick_process(manager, lock);
    #imu_fusion.start();

    #p.is_alive()
    #p.terminate()
    #gl.join();
    #imu_fusion.join();
    