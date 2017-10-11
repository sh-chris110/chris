#!/usr/bin/python
from OpenGL.GL import *  
from OpenGL.GLU import *  
from OpenGL.GLUT import *  
from PIL import Image


#########
win_width = 600;
win_heiht = 480;
########
img_path = "1.jpeg"
texture_name = 1;

def loadTexture(img_path, texture_name):
    img = Image.open(img_path)
    width, height = img.size
    img = img.tobytes('raw', 'RGBX', 0, -1)
    glGenTextures(2)
    glBindTexture(GL_TEXTURE_2D, texture_name)
    glTexImage2D(GL_TEXTURE_2D, 0, 4, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, img) #using the img to create texture

    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP)
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP)
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
    glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL)
    

def Draw():  
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glLoadIdentity()
    glTranslate(0.0, 0.0, -5.0)

    glBindTexture(GL_TEXTURE_2D, texture_name)
    glBegin(GL_QUADS)        

    glTexCoord2f(1.0, 0.0)
    glVertex3f(-1.0, -1.0, 1.0)

    glTexCoord2f(0.0, 0.0)
    glVertex3f(1.0, -1.0, 1.0)

    glTexCoord2f(1.0, 1.0)
    glVertex3f(1.0, 1.0, 1.0)

    glTexCoord2f(0.0, 1.0)
    glVertex3f(-1.0, 1.0, 1.0)
    glEnd()

    glutSwapBuffers()
   
glutInit()  
glutInitDisplayMode(GLUT_SINGLE | GLUT_RGBA)  
glutInitWindowSize(800, 400)  
glutCreateWindow("IMU Display Demo")  

loadTexture(img_path, texture_name);
glEnable(GL_TEXTURE_2D) # load texture and enable this feature

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
gluPerspective(45.0, float(win_width)/float(win_heiht), 0.1, 100.0)

glMatrixMode(GL_MODELVIEW)

glutDisplayFunc(Draw)  
glutIdleFunc(Draw)  
glutMainLoop()   
