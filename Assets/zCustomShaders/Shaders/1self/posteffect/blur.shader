Shader "zwb/post/blur"
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
				float2 uv[5] : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			float4 _MainTex_TexelSize;
			uniform  int offset;


			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				o.uv[0] = v.uv;
				o.uv[1]=o.uv[0]+_MainTex_TexelSize.xy*half2(1,0)*offset;
				o.uv[2]=o.uv[0]+_MainTex_TexelSize.xy*half2(-1,0)*offset;
				o.uv[3]=o.uv[0]+_MainTex_TexelSize.xy*half2(0,1)*offset;
				o.uv[4]=o.uv[0]+_MainTex_TexelSize.xy*half2(0,-1)*offset;
				return o;
			}
			
			sampler2D _MainTex;
			uniform sampler2D _CameraDepthTexture;
			uniform float dis;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col=0;
				col+=tex2D(_MainTex, i.uv[1]);
				col+=tex2D(_MainTex, i.uv[2]);
				col+=tex2D(_MainTex, i.uv[3]);
				col+=tex2D(_MainTex, i.uv[4]);
				col=col/4;
				fixed4 src=tex2D(_MainTex, i.uv[0]);
				float d=tex2D(_CameraDepthTexture, i.uv[0]).r;
				d=Linear01Depth(d);
				dis=clamp(dis,0,1);
				float ler= floor(abs(d-dis)*1000)/1000;
				if(abs(d-dis)<0.3){
                     return src;
				}else{
					return col;
				}
				//col=lerp(src,col,abs(d-dis));
				
			}
			ENDCG
		}
	}
}
