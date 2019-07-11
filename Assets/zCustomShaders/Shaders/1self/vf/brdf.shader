Shader "zwb/vf/brdf"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TinColor("color",Color)=(1,1,1,1)
		Ka("ka",Range(0,1))=1
		Kd("kd",Range(0,1))=1
		Ks("ks",Range(0,1))=0.3
		shin("shinin",Range(0,10))=6
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

            float Ka;
			float Kd;
			float Ks;
			float shin;
			
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

				float3 ambient=col.rgb*UNITY_LIGHTMODEL_AMBIENT.xyz*col.rgb;

				float3 lightDir=-normalize(UnityWorldSpaceLightDir(i.wPos));
				float3 viewDir=normalize(UnityWorldSpaceViewDir(i.wPos));
                float nl=dot(lightDir,i.wNormal);				
				float diff=max(nl,0);
				diff=diff*0.5+0.5;
				float3 diffColor=diff*_LightColor0.rgb*col.rgb*_TinColor*Kd;

				float3 H=normalize(lightDir+viewDir);
				float3 speColor=float3(0,0,0);
				float nv=dot(i.wNormal,viewDir);
				bool back=nv>0&&nl>0;
				float rs=0;
				if(back){
					float3 T = normalize(cross(i.wNormal,viewDir)); //计算顶点切向量
					float a = dot(-lightDir,T);
					float b = dot(viewDir,T);
					float c = sqrt(1-pow(a,2.0))* sqrt(1-pow(b,2.0)) - a*b; //计算 Bank BRDF 系数
					float brdf = Ks* pow(c, pow(2,shin));
					speColor = brdf * _LightColor0.rgb *diff;
				}


				return float4(ambient+diffColor+speColor,1);
			}
			ENDCG
		}
	}
}
