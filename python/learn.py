#!/usr/bin/python
from OpenGL.GL import *  
from OpenGL.GLU import *  
from OpenGL.GLUT import *  

#########
win_width = 600;
win_heiht = 480;
########

def glut_print( x,  y,  font,  text, r,  g , b , a):

    blending = False 
    if glIsEnabled(GL_BLEND) :
        blending = True

    glColor3f(r,g,b)
    glRasterPos2f(x,y)
    for ch in text :
        glutBitmapCharacter( font , ctypes.c_int( ord(ch) ) )

    if not blending :
        glDisable(GL_BLEND) 
   
def Draw():  
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glLoadIdentity()
    glTranslate(0.0, 0.0, -5.0)
    #glRotatef(87, 0.0, 0.0, 1.0)


    glColor3f(1.0, 0.0, 0.0)
    glLineWidth(5)  
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

    glPointSize(10.0)
    glColor3f(1.0, 1.0, 1.0)
    glBegin(GL_POINTS)
    glVertex3f(0, 0, 0)
    glEnd();

    glPushMatrix();
    glLoadIdentity()
    glTranslate(0.0, 0.0, -5.0)
    glColor3f(1.0, 1.0, 1.0)
    glLineWidth(5)  
    glBegin(GL_LINES)    
    glVertex3f(0, 0, 0)
    glVertex3f(1, 0, 0)
    glEnd()

    glPopMatrix();


    glut_print( 1 , 3 , GLUT_BITMAP_9_BY_15 , "Hello World" , 1.0 , 0.0 , 0.0 , 1.0 )
    #glFlush()  
    glutSwapBuffers()
   
glutInit()  
glutInitDisplayMode(GLUT_SINGLE | GLUT_RGBA)  
glutInitWindowSize(800, 400)  
glutCreateWindow("IMU Display Demo")  

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
