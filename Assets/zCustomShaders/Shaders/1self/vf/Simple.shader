Shader "Custom/Unlit/Simple"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TinColor("color",Color)=(1,1,1,1)
			Ks("ks",Range(0,1))=1
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

				float Ks;
			
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
				fixed4 col = tex2D(_MainTex, i.uv);
				float3 lightDir=normalize(UnityWorldSpaceLightDir(i.wPos));
				float3 viewDir=normalize(UnityWorldSpaceViewDir(i.wPos));
                float ln=dot(lightDir,i.wNormal);				
				float diff=max(ln,0.2);

				float3 diffColor=diff*_LightColor0.rgb*_TinColor;

				float3 h=normalize(lightDir+viewDir);
				float nh=max(0,dot(i.wNormal,h));
				float spe=pow(nh,1024);
				float3 speColor=spe*_LightColor0.rgb*Ks;

				return float4(col.rgb*(diffColor)+speColor,1);
			}
			ENDCG
		}
	}
}
