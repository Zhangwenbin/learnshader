// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "zwb/vf/depthTexture"
{
	Properties
	{
	_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include"Lighting.cginc"
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 depth : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.depth=mul(UNITY_MATRIX_MV,v.vertex).zw;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float d=i.depth.x/i.depth.y;
				// d=d*0.5+0.5;
				float3 depthColor=EncodeFloatRGBA(d);
						
				return float4(depthColor,1);
			}
			ENDCG
		}
	}
}
