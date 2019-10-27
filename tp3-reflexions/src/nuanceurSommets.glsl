#version 410

// Définition des paramètres des sources de lumière
layout (std140) uniform LightSourceParameters
{
    vec4 ambient[3];
    vec4 diffuse[3];
    vec4 specular[3];
    vec4 position[3];      // dans le repère du monde
} LightSource;

// Définition des paramètres des matériaux
layout (std140) uniform MaterialParameters
{
    vec4 emission;
    vec4 ambient;
    vec4 diffuse;
    vec4 specular;
    float shininess;
} FrontMaterial;

// Définition des paramètres globaux du modèle de lumière
layout (std140) uniform LightModelParameters
{
    vec4 ambient;       // couleur ambiante globale
    bool twoSide;       // éclairage sur les deux côtés ou un seul?
} LightModel;

layout (std140) uniform varsUnif
{
    // partie 1: illumination
    int typeIllumination;     // 0:Gouraud, 1:Phong
    bool utiliseBlinn;        // indique si on veut utiliser modèle spéculaire de Blinn ou Phong
    bool afficheNormales;     // indique si on utilise les normales comme couleurs (utile pour le débogage)
    // partie 2: texture
    int numTexCoul;           // numéro de la texture de couleurs appliquée
    int numTexNorm;           // numéro de la texture de normales appliquée
    int afficheTexelFonce;    // un texel foncé doit-il être affiché 0:normalement, 1:mi-coloré, 2:transparent?
};

uniform mat4 matrModel;
uniform mat4 matrVisu;
uniform mat4 matrProj;
uniform mat3 matrNormale;

/////////////////////////////////////////////////////////////////

layout(location=0) in vec4 Vertex;
layout(location=2) in vec3 Normal;
layout(location=3) in vec4 Color;
layout(location=8) in vec4 TexCoord;

out Attribs {
    vec4 couleur;
	vec3 normale, obsvec;
	vec3 lumiDir[3];
	vec2 texCoord;
} AttribsOut;

vec4 calculerReflexion( in int j, in vec3 L, in vec3 N, in vec3 O ) // pour la lumière j
{
	float NdotHV = max(0.0, (utiliseBlinn) ? dot(normalize(L + O), N) : dot(reflect(-L, N), O));
    float NdotL = max(0.0, dot(N, L));

    return FrontMaterial.diffuse * LightSource.diffuse[j] * NdotL +
           FrontMaterial.ambient * LightSource.ambient[j] +
           FrontMaterial.specular * LightSource.specular[j] * pow(NdotHV, FrontMaterial.shininess);
}

void main( void )
{
	AttribsOut.texCoord = TexCoord.st;
    // transformation standard du sommet
    gl_Position = matrProj * matrVisu * matrModel * Vertex;

	// vecteur normal N qui sera interpolee par le frag shader
	vec3 N = normalize(matrNormale * Normal);
	AttribsOut.normale = N;
	
	// position P du sommet dans le repere de la camera
	vec3 P = (matrVisu * matrModel * Vertex).xyz;

	// vecteur O de la direction vers l'obs (origine) a partir du sommet
	vec3 O = normalize(-P); 
	AttribsOut.obsvec = O;

	// coord de text a passer au frag shader
	AttribsOut.texCoord = TexCoord.st;

	// vecteur L de la direction de la lumiere dans le repere de la camera
	for (int i = 0; i < 3; i++)
	{
		AttribsOut.lumiDir[i] = (matrVisu * LightSource.position[i]).xyz - P;
	}

	// gouraud illumine avec interp des sommets
	if (typeIllumination == 0)
	{
        vec4 coul =	FrontMaterial.ambient * LightModel.ambient + 
					FrontMaterial.emission;
        for(int i = 0 ; i < 3 ; i++) {
			vec3 L = normalize( AttribsOut.lumiDir[i] ); 
            coul += calculerReflexion(i, L, N, O);
        }
        AttribsOut.couleur = coul;
	}
    else 
	{
		AttribsOut.couleur = Color;
	}
}
