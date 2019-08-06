Shader "zwb/shaderlab/mirror"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
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
				float4 texcorrd:TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			uniform float4x4 projmat;
			uniform sampler2D reftex;
			
			v2f vert (appdata v)
			{
				v2f o;
				float4x4 proj;
				proj=mul(projmat,unity_ObjectToWorld);
				o.vertex=UnityObjectToClipPos(v.vertex);
				o.texcorrd=mul(proj,v.vertex);
				
								
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
                float4 col=tex2Dproj(reftex,i.texcorrd);
				return col;
			}
			ENDCG
		}
	}
}
