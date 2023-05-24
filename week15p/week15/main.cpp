

#include <GL/glut.h>
void display()
{
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    glutSolidTeapot (0.3);
    glutSwapBuffers();
}
void reshape (int w, int h){

    glViewport(0,0,w,h);

    float ar=w/(float)h;

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective( 60, ar, 0.01, 1000);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(0,0,1 ,0,0,0 ,0,1,0);


    glutPostRedisplay();
}
float eyeX = 0, eyeY = 0;
void motion(int x, int y){
    eyeX = (x-150.0)/150.0;
    eyeY = (150.0-y)/150,0;
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(eyeX,eyeY,1,0,0,0,0,1,0);
    glutPostRedisplay();
}
int main(int argc, char** argv)
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE|GLUT_DEPTH);
    glutCreateWindow("week15");

    glutMotionFunc(motion);
    glutDisplayFunc (display);
    glutReshapeFunc (reshape);

    glutMainLoop();
}
