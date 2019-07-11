Shader "zwb/surface/TEXTURE" {
    Properties{
		_MainTex("tex",2D)="white"{}
	}
	SubShader{
        CGPROGRAM
		#pragma surface surf Lambert
        struct Input{
			float2 uv_MainTex;
		};

		sampler2D _MainTex;

		void surf(Input IN,inout SurfaceOutput o){
			o.Albedo=tex2D(_MainTex,IN.uv_MainTex).rgb;
		}
		ENDCG
	}

}
