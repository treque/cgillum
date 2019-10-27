#include "Etat.h"

SINGLETON_DECLARATION_CPP(Etat);

bool       Etat::enPerspective = false;
bool       Etat::enmouvement = false;
bool       Etat::afficheAxes = true;
int        Etat::curLumi = 0;
bool       Etat::positionnelle = true;
GLenum     Etat::modePolygone = GL_FILL;
glm::ivec2 Etat::sourisPosPrec = glm::ivec2(0);
int        Etat::modele = 1;
float      Etat::facteurDeform = 1.0;
bool       Etat::utiliseTess = 0;
GLfloat    Etat::TessLevelInner = 7;
GLfloat    Etat::TessLevelOuter = 7;
float      Etat::temps = 0.0;
float      Etat::dt = 1.0/60.0;
