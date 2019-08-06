Shader "zwb/shaderlab/outline"
{
	Properties
	{
		_outline("out line",Range(0,1))=1
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
			
			v2f vert (appdata v)
			{
				v2f o;
				//v.vertex.xyz+=v.normal*_outline;
				o.vertex = UnityObjectToClipPos(v.vertex);	
			    float3 viewN = normalize (mul ((float3x3)UNITY_MATRIX_IT_MV, v.normal));	
				float2 offset=TransformViewToProjection(viewN.xy);
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
			};

			
			
			v2f vert (appdata v)
			{
				v2f o;				
				o.vertex = UnityObjectToClipPos(v.vertex);	
				o.viewDir=ObjSpaceViewDir(v.vertex);
				o.lightDir=ObjSpaceLightDir(v.vertex);
				o.normal=v.normal;							
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float diff=max(0,dot(i.normal,i.lightDir));
				diff=diff*0.5+0.5;

				return float4(_LightColor0.rgb*diff,1);
			}
			ENDCG
		}
	}
}
