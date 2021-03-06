﻿Shader "zwb/vf/shadowmap"
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
	    ZWrite on
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
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 texc : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _TinColor;

			float Ka;
			float Kd;
			float Ks;			
			uniform float4x4 shadowMatrix;
			uniform sampler2D depthTex;
			uniform sampler2D _CameraDepthTexture;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texc=mul(shadowMatrix,mul(unity_ObjectToWorld,v.vertex));           
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float2 dd=0.5*i.texc.xy/i.texc.w+float2(0.5,0.5);
				float d=i.texc.z/i.texc.w-4/i.texc.w;

                float t=DecodeFloatRGBA(tex2D(depthTex,dd)) ;
				if(d<=t)
				return 0.6;
				else 
				return 0.3;
			}
			ENDCG
		}
	}
}
