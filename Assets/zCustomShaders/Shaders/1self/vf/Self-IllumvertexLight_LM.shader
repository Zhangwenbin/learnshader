Shader "Self-Illumzwb/vf/vertexLight_LM"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color("illumi color",Color)=(1,1,1,1)
		_EmissionLM("Emission",float)=1

	}
	SubShader
	{
                Tags { "RenderType"="Opaque"  }
		Pass
		{
			Tags {  "LightMode"="Vertex" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include"Lighting.cginc"
			#include "UnityCG.cginc"

			uniform float4 _Color;
			float4 _Illumi;


			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal:NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 color:COLOR;
				
			};


			
			v2f vert (appdata v)
			{
					
	            v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color=float4( ShadeVertexLights (v.vertex, v.normal),1)*_Color;
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return i.color+_Color;
			}
			ENDCG
		}
	}
}
