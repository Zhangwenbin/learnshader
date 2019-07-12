Shader "zwb/vf/shadowmap"
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
				float2 uv : TEXCOORD0;
				float3 normal:NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float3 wNormal:TEXCOORD1;
				float3 wPos :TEXCOORD2;
				float2 depth : TEXCOORD3;
	
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _TinColor;

			float Ka;
			float Kd;
			float Ks;			
			uniform float4x4 shadowMatrix;
			uniform sampler2D depthTex;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.wNormal=normalize(UnityObjectToWorldNormal(v.normal));
				o.wPos=mul(unity_ObjectToWorld,v.vertex).xyz;
	            
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

                float4 ndcpos=mul(shadowMatrix,i.wPos);

				float4 dcol = tex2D(depthTex,ndcpos.xy);
				float depth=DecodeFloatRGBA(dcol);
				//ndcpos.z=ndcpos.z/ndcpos.w;

				float pdepth=ndcpos.z/ndcpos.w;
 
				float res=depth<pdepth?1:0.5;
				
		
				return float4(depth,depth,depth,1);
			}
			ENDCG
		}
	}
}
