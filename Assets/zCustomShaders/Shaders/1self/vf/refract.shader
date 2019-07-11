Shader "zwb/vf/refract"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TinColor("color",Color)=(1,1,1,1)
		_alpha("_alpha",Range(0,1))=0.7
		Ka("ka",Range(0,1))=1
		Kd("kd",Range(0,1))=0.7
		Ks("ks",Range(0,1))=1		
		transimittance("transimittance",Range(0,1))=0.7
		etaRatio("etaRatio",Range(0,1))=0.7
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent"}
         
		 Blend srcalpha oneminussrcalpha
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
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _TinColor;

			float _alpha;
			float Ka;
			float Kd;
			float Ks;
			float transimittance;
			float etaRatio;

			samplerCUBE environmentMap;
			
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
				// sample the texture
				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz*Ka;

				fixed4 col = tex2D(_MainTex, i.uv);
				float3 lightDir=-normalize(_WorldSpaceLightPos0.xyz);
				//float3 lightDir=normalize(UnityWorldSpaceLightDir(i.wPos));
				float3 viewDir=normalize(UnityWorldSpaceViewDir(i.wPos));
                float ln=dot(lightDir,i.wNormal);				
				float diff=max(ln,0);
				float3 diffColor=diff*_LightColor0.rgb*_TinColor*Kd*col.rgb;

				float3 h=normalize(lightDir+viewDir);
				float nh=max(0,dot(i.wNormal,h));
				float spe=pow(nh,1024);
				float3 speColor=spe*_LightColor0.rgb*Ks;

				float3 reflectColor=diffColor+speColor;

				float3 T=refract(-viewDir,i.wNormal,etaRatio);
				T = BoxProjectedCubemapDirection( T, i.wPos, unity_SpecCube0_ProbePosition, unity_SpecCube0_BoxMin, unity_SpecCube0_BoxMax);
				float4 envir=UNITY_SAMPLE_TEXCUBE(unity_SpecCube0,T);
				float3 envirColor=DecodeHDR(envir, unity_SpecCube0_HDR);

				return float4(lerp(reflectColor,envirColor,transimittance),_alpha);
			}
			ENDCG
		}
	}
}
