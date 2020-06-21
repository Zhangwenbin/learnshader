Shader "Unlit/sun"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Tint("tint color",Color)=(1,1,1,1)
		_SunPos("sun positon",Vector)=(0,0,0,0)
		_SunColor("sun color",Color)=(1,1,1,1)
		_SunRadius("sun radius",float)=1
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
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 scrPos:TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			//custom properties
			float4 _Tint;
			float4 _SunPos;
			float4 _SunColor;
			float _SunRadius;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.scrPos=ComputeScreenPos(o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				//fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 col = _Tint;
				if(distance(i.scrPos,_SunPos.xy)<_SunRadius){
                      col=_SunColor;
				}
				return col;
			}
			ENDCG
		}
	}
}
