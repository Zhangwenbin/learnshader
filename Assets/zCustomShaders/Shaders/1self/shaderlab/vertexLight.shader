Shader "zwb/shaderlab/vertexLight"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TinColor("color",Color)=(1,1,1,1)
		Ka("ka",Range(0,1))=1
		Kd("kd",Range(0,1))=1
		Ks("ks",Range(0,1))=1
	}
	SubShader
	{

		Pass
		{
			Tags { "RenderType"="Opaque" "LightMode"="Vertex" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include"Lighting.cginc"
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
				float4 color:COLOR;
				
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _TinColor;

			float Ka;
			float Kd;
			float Ks;
			
			v2f vert (appdata v)
			{
					
	            v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color=float4( ShadeVertexLights (v.vertex, v.normal),1);
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return i.color;
			}
			ENDCG
		}
	}
}
