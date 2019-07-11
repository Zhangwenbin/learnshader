Shader "zwb/vf/projectTex"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TinColor("color",Color)=(1,1,1,1)
		Ka("ka",Range(0,1))=1
		Kd("kd",Range(0,1))=1
		Ks("ks",Range(0,1))=1
		_ProjectTex ("_ProjectTex", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" }
		Blend DstColor Oneminusdstcolor

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
				float4 shadowUV:TEXCOORD3;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _TinColor;

			float Ka;
			float Kd;
			float Ks;
			sampler2D _ProjectTex;
			uniform float4x4 unity_Projector;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.wNormal=normalize(UnityObjectToWorldNormal(v.normal));
				o.wPos=mul(unity_ObjectToWorld,v.vertex).xyz;
				o.shadowUV=mul(unity_Projector,v.vertex);
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
				float3 diffColor=diff*_LightColor0.rgb*_TinColor*Kd;

				float3 h=normalize(lightDir+viewDir);
				float nh=max(0,dot(i.wNormal,h));
				float spe=pow(nh,1024);
				float3 speColor=spe*_LightColor0.rgb*Ks;

				//i.shadowUV=i.shadowUV/i.shadowUV.w;
				float4 mapColor;
				//i.shadowUV.x=(i.shadowUV.x+1)*0.5;
				//i.shadowUV.y=(i.shadowUV.y+1)*0.5;
				//mapColor=tex2Dproj(_ProjectTex,UNITY_PROJ_COORD(i.shadowUV));
				mapColor=tex2Dproj(_ProjectTex,i.shadowUV);

				return float4(mapColor.rgb,1);
			}
			ENDCG
		}
	}
}
