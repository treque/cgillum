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

layout(quads) in;

in Attribs {
   vec4 couleur;
   vec3 normale;
   vec4 pos;
   vec4 texCoord;
} AttribsIn[];

out Attribs {
    vec4 couleur;
	vec3 normale, obsvec;
	vec3 lumiDir[3];
	vec2 texCoord;
} AttribsOut;

vec4 calculerReflexion( in int j, in vec3 L, in vec3 N, in vec3 O ) // pour la lumière j
{
	float NdotHV = max((utiliseBlinn) ? dot(normalize(L + O), N) : dot(reflect(-L, N), O), 0.0);
    float NdotL = max(dot(N, L), 0.0);

	vec4 ambient = LightSource.ambient[j] * FrontMaterial.ambient;
	vec4 diffuse = LightSource.diffuse[j] * FrontMaterial.diffuse * NdotL;
	
	vec4 spec = vec4( 0.0 );
	if ( NdotL > 0.0 )
		spec = LightSource.specular[j] * FrontMaterial.specular * pow(NdotHV, FrontMaterial.shininess );

    return ambient + diffuse + spec;
}

float interpole( float v0, float v1, float v2, float v3 ){
    float v01 = mix( v0, v1, gl_TessCoord.x );
    float v32 = mix( v3, v2, gl_TessCoord.x );
    return mix( v01, v32, gl_TessCoord.y );
}
vec2 interpole( vec2 v0, vec2 v1, vec2 v2, vec2 v3 ){
    vec2 v01 = mix( v0, v1, gl_TessCoord.x );
    vec2 v32 = mix( v3, v2, gl_TessCoord.x );
    return mix( v01, v32, gl_TessCoord.y );
}
vec3 interpole( vec3 v0, vec3 v1, vec3 v2, vec3 v3 ){
    vec3 v01 = mix( v0, v1, gl_TessCoord.x );
    vec3 v32 = mix( v3, v2, gl_TessCoord.x );
    return mix( v01, v32, gl_TessCoord.y );
}
vec4 interpole( vec4 v0, vec4 v1, vec4 v2, vec4 v3 ){
    vec4 v01 = mix( v0, v1, gl_TessCoord.x );
    vec4 v32 = mix( v3, v2, gl_TessCoord.x );
    return mix( v01, v32, gl_TessCoord.y );
}

void main()
{
    vec4 Couleur = interpole( AttribsIn[0].couleur, AttribsIn[1].couleur, AttribsIn[3].couleur, AttribsIn[2].couleur );
    vec3 Normale = interpole( AttribsIn[0].normale, AttribsIn[1].normale, AttribsIn[3].normale, AttribsIn[2].normale );
    vec4 Vertex = interpole( AttribsIn[0].pos, AttribsIn[1].pos, AttribsIn[3].pos, AttribsIn[2].pos );
    vec4 TexCoord = interpole( AttribsIn[0].texCoord, AttribsIn[1].texCoord, AttribsIn[3].texCoord, AttribsIn[2].texCoord );

	AttribsOut.texCoord = TexCoord.st;

    // transformation standard du sommet
    gl_Position = interpole( gl_in[0].gl_Position, gl_in[1].gl_Position, gl_in[3].gl_Position, gl_in[2].gl_Position );
    gl_Position = matrProj * matrVisu * matrModel * Vertex;

	vec3 P = (matrVisu * matrModel * Vertex).xyz;
	vec3 O = normalize(-P); 
	AttribsOut.obsvec = O;
	vec3 N = normalize(matrNormale * Normale);
	AttribsOut.normale = N;

	// vecteur L de la direction de la lumiere dans le repere de la camera
	vec3 L[3];
	for (int i = 0; i < 3; i++)
	{
		// LightSource.position n'est pas encore dans le repere de la camera
		L[i] = normalize( (matrVisu * LightSource.position[i]).xyz - P ); 
		AttribsOut.lumiDir[i] = L[i];
	}

	// gouraud illumine avec interp des sommets
	if (typeIllumination == 0) //GOURAUD
	{
        AttribsOut.couleur = vec4(0.0);
        for(int i = 0 ; i < 3 ; i++) {
            AttribsOut.couleur += calculerReflexion(i, L[i], N, O);
        }
	}
    else // Phong
	{
		AttribsOut.couleur = Couleur;
	}
}
