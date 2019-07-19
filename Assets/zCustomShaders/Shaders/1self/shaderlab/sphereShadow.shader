Shader "zwb/shaderlab/sphereShadow"
{
	Properties{
		_intensity("alpha",Range(0,1))=0
	}
	
	SubShader
	{
        	
		Pass{
			Tags{"LightMode"="ForwardBase"}
            Blend srccolor dstcolor  
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"

			uniform float3 spherePos;
			uniform float sphereR;
			float _intensity;

			struct v2f{
				float4 pos:SV_POSITION;
				float3 litDir:TEXCOORD0;
				float3 oDir:TEXCOORD1;
				float4 vertexLight:TEXCOORD2;

			};


			v2f vert(appdata_base v )
			{
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				float3 wPos=mul(unity_ObjectToWorld,v.vertex).xyz;
				o.oDir=spherePos-wPos;
				o.litDir=UnityWorldSpaceLightDir(v.vertex);
				o.vertexLight=_LightColor0*max(0,dot(o.litDir,UnityObjectToWorldNormal(v.normal)));	
				return o;					
			}

			fixed4 frag(v2f i):Color
			{
				float dis=length(i.oDir);
				i.litDir=normalize(i.litDir);
				i.oDir=normalize(i.oDir);
                float cosV=dot(i.litDir,i.oDir);
				float sinV=sin(acos(max(0,cosV)));
				float rd=dis*sinV;
				float shadow=step(sphereR,rd);
				
				float atten=pow(rd/sphereR,4);
				float c=lerp((1-_intensity),1,min(1,shadow+atten));

				return i.vertexLight*c;
			}

			ENDCG
		}

// Pass{
// 			Tags{"LightMode"="ForwardAdd"}
//             Blend srccolor dstcolor  
// 			CGPROGRAM
// 			#pragma vertex vert
// 			#pragma fragment frag
// 			#include "UnityCG.cginc"
// 			#include "UnityLightingCommon.cginc"

// 			uniform float3 spherePos;
// 			uniform float sphereR;
// 			float _intensity;

// 			struct v2f{
// 				float4 pos:SV_POSITION;
// 				float3 litDir:TEXCOORD0;
// 				float3 oDir:TEXCOORD1;
// 				float4 vertexLight:TEXCOORD2;

// 			};


// 			v2f vert(appdata_base v )
// 			{
// 				v2f o;
// 				o.pos=UnityObjectToClipPos(v.vertex);
// 				float3 wPos=mul(unity_ObjectToWorld,v.vertex).xyz;
// 				o.oDir=spherePos-wPos;
// 				o.litDir=UnityWorldSpaceLightDir(v.vertex);
// 				o.vertexLight=_LightColor0*max(0,dot(o.litDir,UnityObjectToWorldNormal(v.normal)));	
// 				return o;					
// 			}

// 			fixed4 frag(v2f i):Color
// 			{
// 				float dis=length(i.oDir);
// 				i.litDir=normalize(i.litDir);
// 				i.oDir=normalize(i.oDir);
//                 float cosV=dot(i.litDir,i.oDir);
// 				float sinV=sin(acos(max(0,cosV)));
// 				float rd=dis*sinV;
// 				float shadow=step(sphereR,rd);
// 				if(rd>sphereR){
//                  return i.vertexLight;
// 				}else{
//                 float atten=pow(rd/sphereR,4);
// 				float c=lerp((1-_intensity),1,min(1,shadow+atten));

// 				return float4(0.015,0.015,0.015,10)*c;
// 				}
				
				
// 			}

// 			ENDCG
// 		}
		
	}
}
