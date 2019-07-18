Shader "zwb/vf/forwardLight"
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

		Pass
		{
			Tags { "RenderType"="Opaque" "LightMode"="ForwardBase" }
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
				float3 color:COLOR;
				
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
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color=Shade4PointLights (unity_4LightPosX0, unity_4LightPosY0, 
				unity_4LightPosZ0,unity_LightColor[0].rgb, 
				unity_LightColor[1].rgb, unity_LightColor[2].rgb,
				 unity_LightColor[3].rgb,unity_4LightAtten0,mul(unity_ObjectToWorld, v.vertex).xyz, 
				 UnityObjectToWorldNormal(v.normal));
				
				return o;
			}


			
			fixed4 frag (v2f i) : SV_Target
			{
				return float4( i.color+_LightColor0,1);
			}
			ENDCG
		}
	}
}
