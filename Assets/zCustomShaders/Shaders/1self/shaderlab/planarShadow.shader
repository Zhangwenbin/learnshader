Shader "zwb/shaderlab/planarShadow"
{
	
	SubShader
	{

		Pass
		{
			Tags{"LightMode"="ForwardBase"}
			Material{
				Diffuse(1,1,1,1)
				
				}
			Lighting on
					
		}
		
		Pass{
			Tags{"LightMode"="ForwardBase"}
			Blend DstColor SrcColor
			Offset -1,-1
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			 float4x4 _world2ground;
			 float4x4 _ground2world;

			float4 vert(float4 vertex:POSITION ):SV_POSITION
			{
			

				float4 vt;
				vt=mul(unity_ObjectToWorld,vertex);
				vt=mul(_world2ground,vt);

				float3 lightDir=WorldSpaceLightDir(vertex).xyz;
				lightDir=mul((float3x3)_world2ground,lightDir);
				lightDir=normalize(lightDir);
         				
				float2 leng=(vt.y/lightDir.y)*lightDir.xz;
				vt.xz=vt.xz-leng;
	
			    vt.y=0;
				vt=mul(_ground2world,vt);
				vt=mul(unity_WorldToObject,vt);


				return UnityObjectToClipPos(vt);
			}

			fixed4 frag(void):Color
			{
				return fixed4(0.3,0.3,0.3,1);
			}

			ENDCG
		}

		Pass{
			Tags{"LightMode"="ForwardAdd"}
			Blend DstColor SrcColor
			Offset -1.5,-1
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			 float4x4 _world2ground;
			 float4x4 _ground2world;

			 struct v2f{
				 float4 pos:SV_POSITION;
				 float atten:TEXCOORD0;
			 };


			v2f vert(float4 vertex:POSITION )
			{
			
                v2f o;
				float4 vt;
				vt=mul(unity_ObjectToWorld,vertex);
				vt=mul(_world2ground,vt);

				float3 lightDir=WorldSpaceLightDir(vertex).xyz;
				lightDir=mul((float3x3)_world2ground,lightDir);
				lightDir=normalize(lightDir);
           
				
				float2 leng=(vt.y/lightDir.y)*lightDir.xz;
				vt.xz=vt.xz-leng;
				vt.y=0;
				vt=mul(_ground2world,vt);
				vt=mul(unity_WorldToObject,vt);
                o.pos=UnityObjectToClipPos(vt);
				o.atten=distance(vt,vertex);
                return o;
				
			}

			fixed4 frag(v2f i):Color
			{
				return smoothstep(0,1,i.atten/10); 
			}

			ENDCG
		}
	}
}
