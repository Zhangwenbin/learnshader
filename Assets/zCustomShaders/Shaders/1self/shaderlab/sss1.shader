Shader "zwb/shaderlab/sss1"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_tint("tint",Color)=(1,1,1,1)
		_disadjust("dis adjust",float)=0
		_atten("atten",float)=0
	}
	SubShader
	{
		Tags {  "lightmode"="forwardadd" }
		LOD 100
		Pass
		{

			Cull back 
			
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
				float3 normal:TEXCOORD1;
				float3 litDir:TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _disadjust;
			float _atten;
			float4 _tint;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normal=UnityObjectToWorldNormal(v.normal);
				o.litDir=WorldSpaceLightDir(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
		
				float3 n=normalize(i.normal);
				float diff=max(0,dot(n,i.litDir));
				diff=diff*0.5+0.5;

				float3 litDir=i.litDir;

				float dis=length(litDir);

				dis=max(0,dis-_disadjust);
				float att=1/(1+dis*dis);
				att=pow(att,_atten);
				_tint=_tint*att*diff;


				return _tint;
			}
			ENDCG
		}
	}
}
