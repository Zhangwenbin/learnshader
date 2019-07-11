Shader "zwb/surface/Fog" {
    Properties{
		_MainTex("tex",2D)="white"{}
		_BumpTex("bump",2D)="white"{}
		_FogColor("fog",Color)=(1,1,1,1)
	}
	SubShader{
        CGPROGRAM
		#pragma surface surf Lambert vertex:vert finalcolor:myFinal
        struct Input{
			float2 uv_MainTex;
			float2 uv_BumpTex;
			float fog;
		};

		sampler2D _MainTex;
		sampler2D _BumpTex;
		float4 _FogColor;

		void vert(inout appdata_full v,out Input o){
			UNITY_INITIALIZE_OUTPUT(Input,o);
           float4 hpos=UnityObjectToClipPos(v.vertex);
		   o.fog=min (1, dot (hpos.xy, hpos.xy) * 0.1);
		}

		void myFinal(Input i,SurfaceOutput o,inout fixed4 color){
              color.rgb = lerp (color.rgb, _FogColor, i.fog);
		}

		void surf(Input IN,inout SurfaceOutput o){
			o.Albedo=tex2D(_MainTex,IN.uv_MainTex).rgb;
			o.Normal=UnpackNormal(tex2D(_BumpTex,IN.uv_BumpTex));
		}
		ENDCG
	}

}
