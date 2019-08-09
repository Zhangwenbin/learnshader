﻿Shader "zwb/post/colorcorrection"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			float4 _MainTex_TexelSize;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv=v.uv;
			
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D rgbtex;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				float red=tex2D(rgbtex,half2(col.r,0.5/4)).rgb*fixed3(1,0,0).r;
				float green=tex2D(rgbtex,half2(col.g,1.5/4)).rgb*fixed3(0,1,0).g;
				float blue=tex2D(rgbtex,half2(col.b,2.5/4)).rgb*fixed3(0,0,1).b;

				//return float4(col.rgb*0.5,col.a);

				return float4(red,green,blue,col.a);

				
			}
			ENDCG
		}
	}
}
