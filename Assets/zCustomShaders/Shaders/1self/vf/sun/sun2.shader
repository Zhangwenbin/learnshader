Shader "Unlit/sun2"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
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
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
		//	#pragma multi_compile_fog

		#include "UnityCG.cginc"


	

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
			//	UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float4 scrPos : TEXCOORD2;
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

		float rand(float x) {
			float res = 0.0;

			for (int i = 0; i < 5; i++) {
				res += 0.240 * float(i) * sin(x * 0.68171 * float(i));

			}
			return res;

		}

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.scrPos = ComputeScreenPos(o.vertex);
			//	UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			float2 rayIntersectSphere(float3 rayStart, float3 rayDir, float3 c, float r)
				//直线与球体求交，退化使用可用于直线与圆求交
				//ref: https://en.wikipedia.org/wiki/Line%E2%80%93sphere_intersection
			{
				float3 l = rayDir;
				float3 o = rayStart;
				float A = dot(l, o - c);
				float B = dot(o - c, o - c);
				float C = A * A - (B - r * r);
				if (C < 0) {
					return float2(1000,1000);//infinity
				}
				else {
					float sqrtC = sqrt(C);
					float2 d = float2(-A - sqrtC,-A+sqrtC);
					return d;
				}
			}
			fixed4 frag(v2f i) : SV_Target
			{

				half2 gl_FragCoord = ((i.scrPos.xy / i.scrPos.w) * _ScreenParams.xy);
				half2 moonPos = mouse.xy/ _ScreenParams.xy - 0.5;
				float aspect = _ScreenParams.x / _ScreenParams.y;
				half2 position = (gl_FragCoord.xy / _ScreenParams.xy) - 0.5;
					position.x *= aspect;
					moonPos.x *= aspect;


				//----不带godray的太阳、月亮和天空
				half3 color = getColor(position, moonPos);

				float dis_mp=distance(moonPos,position);
				float dis_sp=distance(_SunPos,position);
				float dis_ms=distance(_SunPos,moonPos);

				float4 skyColor=_DayColor;

				if (dis_ms < _SunRadius+_MoonRadius) 
				{
					skyColor = lerp(_NightColor, _DayColor, dis_ms / _SunRadius+_MoonRadius);
				}
				else{
					skyColor = _DayColor;
				}

				
				//----用解析法计算godray（以太阳为中心径向模糊）。这段是唯一本质上与 知乎@马甲 同学代码的不同之处，用解析公式代替了暴力迭代。 
				float Length =dis_sp;
				float2 dir = (position-_SunPos)/Length;
				float2 d=rayIntersectSphere(float3(_SunPos.xy, 0), float3(dir.xy, 0), float3(moonPos.xy, 0), _MoonRadius);
				d = max(float2(0, 0), d);
				float sunCoverButMoonNotCoverLength=0;//sunPos到position连线上多大长度被太阳覆盖但又不被月亮覆盖
				float rmin = min(Length, _SunRadius);
				if (d.x >rmin) {
					sunCoverButMoonNotCoverLength = rmin;
				}
				else{
					if (d.y > rmin) {
						sunCoverButMoonNotCoverLength = d.x;
					}
					else {
						sunCoverButMoonNotCoverLength = rmin - (d.y - d.x);
					}
				}
				float moonCoverLength = 0;//sunPos到position连线上多大长度被月亮覆盖
				if (d.x > Length) {
					moonCoverLength = 0;
				}
				else {
					if (d.y > Length) {
						moonCoverLength = Length - d.x;
					}
					else {
						moonCoverLength = d.y - d.x;
					}
				}
				float skyCoverLength = Length - sunCoverButMoonNotCoverLength - moonCoverLength;//sunPos到position连线上多大长度被天空覆盖（既不被太阳覆盖又不被月亮覆盖）
				float3 godrayColor = (skyCoverLength * skyColor + sunCoverButMoonNotCoverLength * _SunColor + moonCoverLength * _MoonColor)/Length;//sunPos到position连线上的平均颜色
				float3 light = godrayColor;//为了和 知乎@马甲 同学的代码保持对应，我这里仍然使用light这个变量名
		
			
				//----衰减
				float attenFac = 1/(_SunPower*max(.01, dot(dis_sp, dis_sp)));
				light *= attenFac;
			
				//----星星
				
				half2 star = gl_FragCoord.xy;			
				if (rand(star.y * star.x) >= 2.1 && rand(star.y + star.x) >= .7) {
					if (dis_ms<_MoonRadius+_SunRadius&&dis_sp>_SunRadius&&dis_mp>_MoonRadius) {
						color = lerp(half4(2.0,2,2,1), half4(0.2, 0.3, 0.5,1), dis_ms / _MoonRadius+_SunRadius);
					}
				}

			

				//---用不带godray的颜色(color)+gray颜色(light)，作为最终颜色
				return half4(color.rgb + light, 1.0);
			}
			ENDCG
		}
	}
}