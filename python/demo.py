#!/usr/bin/python
from multiprocessing import Process, Manager, Lock
import serial
import os
import time
    

from OpenGL.GL import *
from OpenGL.GLUT import *
from OpenGL.GLU import *
from PIL import Image

class opengl_process():
    imu = None;
    imu_lock = None;
    win_width = 600;
    win_heiht= 480;
    win_title = "OpenGL Display Demo"
    def Draw_cube(self):
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
        glLoadIdentity()
        glTranslate(0.0, 0.0, -3.0)

        glBindTexture(GL_TEXTURE_2D, 0)
        glBegin(GL_QUADS)        
        glTexCoord2f(0.0, 0.0)
        glVertex3f(-1.0, -1.0, 1.0)
        glTexCoord2f(1.0, 0.0)
        glVertex3f(1.0, -1.0, 1.0)
        glTexCoord2f(1.0, 1.0)
        glVertex3f(1.0, 1.0, 1.0)
        glTexCoord2f(0.0, 1.0)
        glVertex3f(-1.0, 1.0, 1.0)
        glEnd()

        glBindTexture(GL_TEXTURE_2D, 1)
        glBegin(GL_QUADS)        
        glTexCoord2f(1.0, 0.0)
        glVertex3f(-1.0, -1.0, -1.0)
        glTexCoord2f(1.0, 1.0)
        glVertex3f(-1.0, 1.0, -1.0)
        glTexCoord2f(0.0, 1.0)
        glVertex3f(1.0, 1.0, -1.0)
        glTexCoord2f(0.0, 0.0)
        glVertex3f(1.0, -1.0, -1.0)
        glEnd()

        glBindTexture(GL_TEXTURE_2D, 2)
        glBegin(GL_QUADS)
        glTexCoord2f(0.0, 1.0)
        glVertex3f(-1.0, 1.0, -1.0)
        glTexCoord2f(0.0, 0.0)
        glVertex3f(-1.0, 1.0, 1.0)
        glTexCoord2f(1.0, 0.0)
        glVertex3f(1.0, 1.0, 1.0)
        glTexCoord2f(1.0, 1.0)
        glVertex3f(1.0, 1.0, -1.0)
        glEnd()

        glBindTexture(GL_TEXTURE_2D, 3)
        glBegin(GL_QUADS)        
        glTexCoord2f(1.0, 1.0)
        glVertex3f(-1.0, -1.0, -1.0)
        glTexCoord2f(0.0, 1.0)
        glVertex3f(1.0, -1.0, -1.0)
        glTexCoord2f(0.0, 0.0)
        glVertex3f(1.0, -1.0, 1.0)
        glTexCoord2f(1.0, 0.0)
        glVertex3f(-1.0, -1.0, 1.0)
        glEnd()

        glBindTexture(GL_TEXTURE_2D, 4)
        glBegin(GL_QUADS)        
        glTexCoord2f(1.0, 0.0)
        glVertex3f(1.0, -1.0, -1.0)
        glTexCoord2f(1.0, 1.0)
        glVertex3f(1.0, 1.0, -1.0)
        glTexCoord2f(0.0, 1.0)
        glVertex3f(1.0, 1.0, 1.0)
        glTexCoord2f(0.0, 0.0)
        glVertex3f(1.0, -1.0, 1.0)
        glEnd()

        glBindTexture(GL_TEXTURE_2D, 5)
        glBegin(GL_QUADS)
        glTexCoord2f(0.0, 0.0)
        glVertex3f(-1.0, -1.0, -1.0)
        glTexCoord2f(1.0, 0.0)
        glVertex3f(-1.0, -1.0, 1.0)
        glTexCoord2f(1.0, 1.0)
        glVertex3f(-1.0, 1.0, 1.0)
        glTexCoord2f(0.0, 1.0)
        glVertex3f(-1.0, 1.0, -1.0)
        glEnd()

        glutSwapBuffers()
    
    def Draw(self):
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

        glLoadIdentity()
        glTranslate(-1.0, 0.0, 0.0)
        #glRotatef(87, 0.0, 0.0, 1.0)

        glLineWidth(5)  
        glColor3f(1.0, 0.0, 0.0)
        glBegin(GL_LINES)    
        glVertex3f(0, 0, 0)
        glVertex3f(1, 0, 0)
        glEnd()

        #glBegin(GL_TRIANGLES);
        #glVertex3f(-1.0f, -0.5f, -4.0f);
        #glVertex3f( 1.0f, -0.5f, -4.0f);
        #glVertex3f( 0.0f,  0.5f, -4.0f);
        #glEnd();

        glColor3f(0.0, 1.0, 0.0)
        glBegin(GL_LINES)    
        glVertex3f(0, 0, 0)
        glVertex3f(0, 1, 0)
        glEnd()


        glColor3f(0.0, 0.0, 1.0)
        glBegin(GL_LINES)    
        glVertex3f(0, 0, 0)
        glVertex3f(0, 0, 1)
        glEnd()

        #glPointSize(10.0)
        #glColor3f(1.0, 1.0, 1.0)
        #glBegin(GL_POINTS)
        #glVertex3f(0, 0, 0)
        #glEnd();

        #glPushMatrix();
        #glLoadIdentity()
        #glTranslate(0.0, 0.0, -5.0)
        #glColor3f(1.0, 1.0, 1.0)
        #glLineWidth(5)  
        #glBegin(GL_LINES)    
        #glVertex3f(0, 0, 0)
        #glVertex3f(1, 0, 0)
        #glEnd()
        #glPopMatrix();


        self.glut_print( 1 , 1 , GLUT_BITMAP_9_BY_15 , "Hello World" , 1.0 , 0.0 , 0.0 , 1.0 )
        glutSwapBuffers()

    def glut_print(self, x,  y,  font,  text, r,  g , b , a):

        blending = False 
        if glIsEnabled(GL_BLEND) :
            blending = True

        glColor3f(r,g,b)
        glRasterPos2f(x,y)
        for ch in text :
            glutBitmapCharacter( font , ctypes.c_int( ord(ch) ) )
    
        if not blending :
            glDisable(GL_BLEND) 

    def __init__(self, imu, imu_lock):
        self.imu = imu;
        self.imu_lock = imu_lock;

        glutInit()
        glutInitDisplayMode(GLUT_SINGLE | GLUT_RGBA)  
        #glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH)
        glutInitWindowSize(self.win_width, self.win_heiht)
        self.window = glutCreateWindow(self.win_title)
        #glutDisplayFunc(self.Draw)
        glutDisplayFunc(self.Draw_cube)
        glutIdleFunc(None)
        self.initialize_texture()

        glEnable(GL_TEXTURE_2D)
        glClearColor(0.0, 0.0, 0.0, 0.0)
        glClearDepth(1.0)
        glDepthFunc(GL_LESS) #how to calculate the depth data
        glShadeModel(GL_SMOOTH)
        glEnable(GL_CULL_FACE) #enable light model
        glCullFace(GL_BACK) # disable back light model
        glEnable(GL_POINT_SMOOTH)
        glEnable(GL_LINE_SMOOTH)
        glEnable(GL_POLYGON_SMOOTH)
        glMatrixMode(GL_PROJECTION)
        glHint(GL_POINT_SMOOTH_HINT,GL_NICEST)
        glHint(GL_LINE_SMOOTH_HINT,GL_NICEST)
        glHint(GL_POLYGON_SMOOTH_HINT,GL_FASTEST)
        glLoadIdentity()
        gluPerspective(45.0, float(self.win_width)/float(self.win_heiht), 1, 100.0)
        glMatrixMode(GL_MODELVIEW)

    def run(self): 
        glutMainLoop()

    def initialize_texture(self):
        imgFiles = [str(i)+'.jpeg' for i in range(1,7)]
        for i in range(6):
            img = Image.open(imgFiles[i])
            width, height = img.size
            img = img.tobytes('raw', 'RGBX', 0, -1)
            
            glGenTextures(2)
            glBindTexture(GL_TEXTURE_2D, i)
            glTexImage2D(GL_TEXTURE_2D, 0, 4, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE,img)
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP)
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP)
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
            glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL)

    def __del__(self):
        pass

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
    
    imu_fusion = madgwick_process(imu, imu_lock);
    imu_fusion.start();

    #gl = opengl_process(imu, imu_lock);
    #gl.run(); 

    imu_fusion.join();
