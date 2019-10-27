#ifndef __PIPELINE_H__
#define __PIPELINE_H__

// variables pour l'utilisation des nuanceurs
GLuint prog;      // votre programme de nuanceurs
GLint locVertex = -1;
GLint locNormal = -1;
GLint locTexCoord = -1;
GLint locmatrModel = -1;
GLint locmatrVisu = -1;
GLint locmatrProj = -1;
GLint locmatrNormale = -1;
GLint loclaTextureCoul = -1;
GLint loclaTextureNorm = -1;
GLint locfacteurDeform = -1;
GLint locTessLevelInner = -1;
GLint locTessLevelOuter = -1;
GLuint indLightSource;
GLuint indFrontMaterial;
GLuint indLightModel;
GLuint indvarsUnif;
GLuint progBase;  // le programme de nuanceurs de base
GLint locVertexBase = -1;
GLint locColorBase = -1;
GLint locmatrModelBase = -1;
GLint locmatrVisuBase = -1;
GLint locmatrProjBase = -1;

GLuint vao[2];
GLuint vbo[5];
GLuint vboLumi;
GLuint ubo[4];

// matrices du pipeline graphique
MatricePipeline matrModel, matrVisu, matrProj;

#endif
