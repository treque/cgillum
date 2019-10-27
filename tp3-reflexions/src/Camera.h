#ifndef __CAMERA_H__
#define __CAMERA_H__

//
// variables pour définir le point de vue
//
class Camera
{
public:
    Camera() { theta = -7.0; phi = -5.0; dist = 30.0; }
    void definir()
    {
        matrVisu.LookAt( 0.0, 0.0, dist,  0.0, 0.0, 0.0,  0.0, 1.0, 0.0 );
        matrVisu.Rotate( phi, -1.0, 0.0, 0.0 );
        matrVisu.Rotate( theta, 0.0, -1.0, 0.0 );
    }
    void verifierAngles() // vérifier que les angles ne débordent pas les valeurs permises
    {
        const GLdouble MINPHI = -89.9, MAXPHI = 89.9;
        phi = glm::clamp( phi, MINPHI, MAXPHI );
    }
    double theta;         // angle de rotation de la caméra (coord. sphériques)
    double phi;           // angle de rotation de la caméra (coord. sphériques)
    double dist;          // distance (coord. sphériques)
} camera;

#endif
