Shader "Custom/Unlit/torrance"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TinColor("color",Color)=(1,1,1,1)
		Ks("ks",Range(0,1))=1
		f("f",Range(0,1))=1
		m("m",Range(0,1))=1
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
				float f;
				float m;
			
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
                float nl=dot(lightDir,i.wNormal);				
				float diff=max(nl,0.2);
				float3 diffColor=diff*_LightColor0.rgb*col.rgb*_TinColor;

				float3 H=normalize(lightDir+viewDir);
				float3 speColor=float3(0,0,0);
				float nv=dot(i.wNormal,viewDir);
				bool back=nv>0&&nl>0;
				float rs=0;
				if(back){
					float nh=dot(i.wNormal,H);
					float temp = (nh*nh-1)/(m*m*nh*nh);
					float roughness = (exp(temp))/(pow(m,2)*pow(nh,4.0)); //粗糙度，根据 beckmann 函数
					float vh = dot(viewDir,H);
					float a = (2*nh*nv)/vh;
					float b = (2*nh*nl)/vh;
					float geometric = min(a,b);
					geometric = min(1,geometric); //几何衰减系数
					float fresnelCoe=f+(1-f)*pow(1-vh,5.0); //fresnel 反射系数
					 rs = (fresnelCoe*geometric*roughness)/(nv*nl);
					speColor = rs * _LightColor0 * nl*Ks; // 计算镜面反射光分量（这是重点）
				}


				return float4(diffColor+speColor,1);
			}
			ENDCG
		}
	}
}
