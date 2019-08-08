Shader "zwb/shaderlab/floatobj"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_deep("deep color",Color)=(1,1,1,1)
		_shallow("shallow",Color)=(1,1,1,1)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "queue"="geometry+1" }
		LOD 100

		Pass
		{
			Cull back 
			ZTest less
			Blend one zero
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
		
			
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
				float diff:TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			float4 _shallow;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				o.diff=max(0,dot(v.normal,normalize(ObjSpaceLightDir(v.vertex))));
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				
				float4 col=tex2D(_MainTex,i.uv);
				return float4(i.diff*col.rgb,1) ;
			}
			ENDCG
		}

				Pass
		{ 
			Cull front 
			ZTest greater
			Blend oneminusdstalpha one
			ZWrite off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
		
			
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
				float diff:TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			float4 _deep;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				o.diff=max(0,dot(-v.normal,normalize(ObjSpaceLightDir(v.vertex)) ));
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				
				float4 col=tex2D(_MainTex,i.uv);
				return _deep*i.diff*col;
			}
			ENDCG
		}
	}
}
