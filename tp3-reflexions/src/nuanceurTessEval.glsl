#version 410

layout(quads) in;

in Attribs {
    vec4 couleur;
	vec3 normale, obsvec;
	vec3 lumiDir[3];
	vec2 texCoord;
} AttribsIn[];

out Attribs {
    vec4 couleur;
	vec3 normale, obsvec;
	vec3 lumiDir[3];
	vec2 texCoord;
} AttribsOut;

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
    gl_Position = interpole( gl_in[0].gl_Position, gl_in[1].gl_Position, gl_in[3].gl_Position, gl_in[2].gl_Position );

    AttribsOut.couleur = interpole( AttribsIn[0].couleur, AttribsIn[1].couleur, AttribsIn[3].couleur, AttribsIn[2].couleur );
    AttribsOut.normale = interpole( AttribsIn[0].normale, AttribsIn[1].normale, AttribsIn[3].normale, AttribsIn[2].normale );
    AttribsOut.obsvec = interpole( AttribsIn[0].obsvec, AttribsIn[1].obsvec, AttribsIn[3].obsvec, AttribsIn[2].obsvec );
    AttribsOut.texCoord = interpole( AttribsIn[0].texCoord, AttribsIn[1].texCoord, AttribsIn[3].texCoord, AttribsIn[2].texCoord );

    for(int i = 0 ; i < 3 ; i++) {
        AttribsOut.lumiDir[i] = interpole( AttribsIn[0].lumiDir[i], AttribsIn[1].lumiDir[i], AttribsIn[3].lumiDir[i], AttribsIn[2].lumiDir[i] );
    }
}