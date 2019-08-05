﻿Shader "zwb/shaderlab//parallax"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_parallax("parallax",float)=1
		_parallaxMap("parallamap",2D)=""
		_BumpMap("bump",2D)=""
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
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal:NORMAL;
				float4 tangent:TANGENT;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float3 lightDir:TEXCOORD1;
				float3 viewDir:TEXCOORD2;
				float4 posW:TEXCOORD3;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			float _parallax;
			sampler2D _parallaxMap;
			float4 _parallaxMap_ST;

			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				o.lightDir=ObjSpaceLightDir(v.vertex);
				o.viewDir=ObjSpaceViewDir(v.vertex);
				TANGENT_SPACE_ROTATION;
				o.lightDir=mul(rotation,o.lightDir);
				o.viewDir=mul(rotation,o.viewDir);
				o.posW=mul(unity_ObjectToWorld,v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				
				float p=tex2D(_parallaxMap,i.uv).a;
				float2 offset=ParallaxOffset(p,_parallax,i.viewDir);
				i.uv+=offset;
				fixed4 col = tex2D(_MainTex, i.uv);
				float3 N=UnpackNormal(tex2D(_BumpMap,i.uv));
				float diff=max(0,dot(N,i.lightDir));




				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
                

				return col*diff;
			}
			ENDCG
		}
	}
}
