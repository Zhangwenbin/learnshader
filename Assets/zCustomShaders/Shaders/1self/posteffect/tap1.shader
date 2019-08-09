Shader "zwb/post/tap1"
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
				float2 uv[4] : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			float4 _MainTex_TexelSize;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				float2 uv;
				uv.xy=MultiplyUV(UNITY_MATRIX_TEXTURE0,v.uv);
				float offx=_MainTex_TexelSize.x;
				float offy=_MainTex_TexelSize.y;
				o.uv[0]=uv+float2(-offx,-offy);
				o.uv[1]=uv+float2(-offx,offy);
				o.uv[2]=uv+float2(offx,offy);
				o.uv[3]=uv+float2(offx,-offy);
				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv[0]);
				col += tex2D(_MainTex, i.uv[1]);
				col += tex2D(_MainTex, i.uv[2]);
				col += tex2D(_MainTex, i.uv[3]);
				return col/4;
			}
			ENDCG
		}
	}
}
