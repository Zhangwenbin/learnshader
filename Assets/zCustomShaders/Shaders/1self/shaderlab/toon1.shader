Shader "zwb/shaderlab/toon1"
{
	Properties
	{
		_outline("out line",Range(0,1))=1
		_factor("factor",Range(0,1))=0
		_steps("steps",float)=10
		_toonFactor("toon factor",Range(0,1))=1
		_MainTex("main tex",2D)=""
	}
	SubShader
	{
		Tags { "RenderType"="Opaque"  }

		Pass
		{
			Tags { "LightingMode"="Always" }
		
			Cull front
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal:NORMAL;
			};

			struct v2f
			{								
				float4 vertex : SV_POSITION;
			};

			float _outline;
			float _factor;
			float _steps;
			
			v2f vert (appdata v)
			{
				v2f o;

				//法线方向挤出
				//v.vertex.xyz+=v.normal*_outline;
				o.vertex = UnityObjectToClipPos(v.vertex);	

				//屏幕空间法线方向挤出
				float3 dirn=v.normal;

				//屏幕空间顶点方向挤出
				float3 dir=normalize(v.vertex.xyz);

				float d=dot(dirn,dir);
				d=(d/_factor+1)/(1+1/_factor);
				d=clamp(d,0,1);
				dir=lerp(dirn,dir,d);
			    dir = normalize (mul ((float3x3)UNITY_MATRIX_IT_MV, dir));	
				float2 offset=TransformViewToProjection(dir.xy);

                offset=normalize(offset);
				o.vertex.xy+=offset*o.vertex.z*_outline;	
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				
				return 0;
			}
			ENDCG
		}

			Pass
		{
	
			Tags { "LightingMode"="ForwardBase" }
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal:NORMAL;
			};

			struct v2f
			{								
				float4 vertex : SV_POSITION;
				
				float3 viewDir:TEXCOORD0;
				float3 lightDir:TEXCOORD1;
				float3 normal:TEXCOORD2;
				float2 uv:TEXCOORD3;
			};

			float _steps;
			float _toonFactor;

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;				
				o.vertex = UnityObjectToClipPos(v.vertex);	
				o.viewDir=ObjSpaceViewDir(v.vertex);
				o.lightDir=ObjSpaceLightDir(v.vertex);
				o.normal=v.normal;		
				o.uv= TRANSFORM_TEX(v.uv,_MainTex);					
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float diff=max(0,dot(i.normal,i.lightDir));
				diff=smoothstep(0,1,diff);
				float toon=floor(diff*_steps)/_steps;
				diff=lerp(diff,toon,_toonFactor);

				float3 tinColor=tex2D(_MainTex,i.uv);


				return float4(tinColor*_LightColor0.rgb*diff,1);
			}
			ENDCG
		}
	}
}
