  #version 410

layout(location=0) in vec4 Vertex;
layout(location=2) in vec3 Normal;
layout(location=3) in vec4 Color;
layout(location=8) in vec4 TexCoord;

out Attribs {
   vec4 couleur;
   vec3 normale;
   vec4 pos;
   vec4 texCoord;
} AttribsOut;

void main( void )
{
    AttribsOut.couleur = Color;
    AttribsOut.normale = Normal;
    AttribsOut.pos = Vertex;
    AttribsOut.texCoord = TexCoord;
}