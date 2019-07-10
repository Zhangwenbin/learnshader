Shader "Custom/Transparent" {
    Properties{
		_MainTex("tex",2D)="white"{}
		_BumpTex("bump",2D)="white"{}
		_Alpha("alpha",Range(0,1))=1
	}
	SubShader{
		//Tags{"RenderType"="Transparent" "Queue"="Transparent"}
		//Blend zero zero
        CGPROGRAM
		#pragma surface surf Lambert alpha:blend
        struct Input{
			float2 uv_MainTex;
			float2 uv_BumpTex;
		};

		sampler2D _MainTex;
		sampler2D _BumpTex;
		float _Alpha;

		void surf(Input IN,inout SurfaceOutput o){
			o.Albedo=tex2D(_MainTex,IN.uv_MainTex).rgb;
			o.Normal=UnpackNormal(tex2D(_BumpTex,IN.uv_BumpTex));
			o.Alpha=_Alpha;
		}
		ENDCG
	}

}
