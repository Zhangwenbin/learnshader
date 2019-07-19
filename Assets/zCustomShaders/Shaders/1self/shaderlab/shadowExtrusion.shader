Shader "zwb/shaderlab/shadowExtrusion"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TinColor("color",Color)=(1,1,1,1)
		Ka("ka",float)=1
		Kd("kd",Range(0,1))=1
		Ks("ks",Range(0,1))=1
	}
	SubShader
	{

		Pass
		{
			Tags { "RenderType"="Opaque" "LightMode"="ForwardBase" }
			Cull back
		
			ColorMask R
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
				float4 vertex : SV_POSITION;
				float4 color:COLOR;
				
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _TinColor;

			float Ka;
			float Kd;
			float Ks;
			
			v2f vert (appdata v)
			{
					
	            v2f o;
				
				float3 litDir=UnityWorldSpaceLightDir(v.vertex);
				float backF=dot(normalize(litDir) ,UnityObjectToWorldNormal(v.vertex));
				o.color=_LightColor0*max(0.1,backF);
                float extrusion=backF<0?1:0;
				litDir=mul((float3x3)unity_WorldToObject,litDir);
				litDir=normalize(litDir);
				v.vertex-=float4(litDir,1)*Ka*extrusion ;
                o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return i.color;
			}
			ENDCG
			SetTexture[_MainTex] {ConstantColor(1,1,1,1) Combine constant}
		}

	}
}
