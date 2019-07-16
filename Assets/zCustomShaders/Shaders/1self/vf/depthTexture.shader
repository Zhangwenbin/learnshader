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
			     //UNITY_TRANSFER_DEPTH(o.depth);
				 o.depth=o.vertex.zw;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				 float d=i.depth.x/i.depth.y-4/i.depth.y;
				//d=Linear01Depth(d);
				return EncodeFloatRGBA(d);
			}
			ENDCG
		}
	}
}
