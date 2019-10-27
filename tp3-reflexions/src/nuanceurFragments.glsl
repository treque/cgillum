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

uniform sampler2D laTextureCoul;
uniform sampler2D laTextureNorm;

/////////////////////////////////////////////////////////////////

in Attribs {
    vec4 couleur;
	vec3 normale, obsvec;
	vec3 lumiDir[3];
	vec2 texCoord;
} AttribsIn;

out vec4 FragColor;

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
	vec3 N = normalize(AttribsIn.normale);
	vec3 O = normalize(AttribsIn.obsvec);


    if(typeIllumination == 1) { 
		vec4 coul =	FrontMaterial.ambient * LightModel.ambient + 
					FrontMaterial.emission;
        for(int i = 0 ; i < 3 ; i++) {         
			vec3 L = normalize( AttribsIn.lumiDir[i] ); 
            coul += calculerReflexion(i, L, N, O);
        }
        FragColor = coul;
    }
    else {
         FragColor = AttribsIn.couleur;
    }

	if (numTexCoul != 0)
	{
		vec4 coulTexture = texture(laTextureCoul, AttribsIn.texCoord);
		FragColor *= coulTexture;

		if (afficheTexelFonce == 1) {
			if(length(coulTexture.rgb) < 0.5) {
                FragColor.a = 0.5;
            }
		}
        else if(afficheTexelFonce == 2) {
            if(length(coulTexture.rgb) < 0.5) {
                FragColor.a = 0.0; // ou discard;
            }
		}
	}

    //if ( afficheNormales ) FragColor = vec4( AttribsIn.normale,1.0);
}
