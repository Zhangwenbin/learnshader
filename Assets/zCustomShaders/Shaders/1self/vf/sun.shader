Shader "Unlit/sun"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Tint("tint color",Color)=(1,1,1,1)
		_SunPos("sun positon",Vector)=(0,0,0,0)
		_SunColor("sun color",Color)=(1,1,1,1)
		_SunRadius("sun radius",Range(0,0.2))=0.2

		_DayColor("day color",Color)=(1,1,1,1)
		_NightColor("night color",Color)=(1,1,1,1)

		_MoonColor("moon color",Color)=(1,1,1,1)
		_MoonRadius("moon radius",Range(0,0.2))=0.15

		_SunPower("sun power",Range(1,600))=50
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

			float4 _DayColor;
			float4 _NightColor;

			float4 _MoonColor;
			float  _MoonRadius;

			float _SunPower;

			uniform half3 mouse;
			uniform half2 resolution;
			uniform int iteration=1;

		float rand(float x) 
		{
			float res = 0.0;

			for (int i = 0; i < 5; i++) {
				res += 0.240 * float(i) * sin(x * 0.68171 * float(i));

			}
			return res;

		}

		half4 getColor(half2 pos, half2 moonPos) 
		{
			half4 day = _DayColor;
			half4 night = _NightColor;
			float ms = distance(moonPos,_SunPos);

			if (distance(pos, moonPos) < _MoonRadius) {
				//月亮
				if (ms < _SunRadius+_MoonRadius) 
				{
				return lerp(float4(0,0,0,0), _MoonColor, ms / (_SunRadius+_MoonRadius));
				}
				return _MoonColor;
			}

			if (distance(pos,_SunPos) < _SunRadius) {
				//太阳
				return _SunColor;
			}
			
			//天空
			if (ms < _SunRadius+_MoonRadius) {
				return lerp(night, day, ms / (_SunRadius+_MoonRadius));
			}
			return day;

		}
			
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

			half2 gl_FragCoord = ((i.scrPos.xy / i.scrPos.w) * _ScreenParams.xy);
			half2 moonPos = mouse.xy/ _ScreenParams.xy - 0.5;
			float aspect = _ScreenParams.x / _ScreenParams.y;
			half2 position = (gl_FragCoord.xy / _ScreenParams.xy) - 0.5;
					position.x *= aspect;
					moonPos.x *= aspect;
			half4 color = getColor(position, moonPos);

			half4 light=half4(0,0,0,0);
			half2 incr = position / float(iteration);
			half2 p = half2(0.0, 0.0) + incr;
			for (int i = 2; i < iteration; i++) {
				light += getColor(p, moonPos);
				p += incr;
			}
			light /= float(iteration) * max(.01, dot(position, position)) * _SunPower;


			half2 star = gl_FragCoord.xy;			
			if (rand(star.y * star.x) >= 2.1 && rand(star.y + star.x) >= .7) {
				float lm = length(moonPos);
				if (lm < 0.15&&distance(position,_SunPos)>_SunRadius&&distance(position,moonPos)>_MoonRadius) {
					color = lerp(half4(2.0,2,2,1), half4(0.2, 0.3, 0.5,1), lm / 0.15);
				}
			}

				return color+light;
			}

		
			ENDCG
		}
	}
}
