Shader "zwb/surface/DetailTexScreen" {
    Properties{
		_MainTex("tex",2D)="black"{}
		_BumpTex("bump",2D)="white"{}
		_DetailTex("detail",2D)="gray"{}
	}
	SubShader{
        CGPROGRAM
		#pragma surface surf Lambert
        struct Input{
			float2 uv_MainTex;
			float2 uv_BumpTex;
			float2 uv_DetailTex;
			float4 screenPos;
		};

		sampler2D _MainTex;
		sampler2D _BumpTex;
		sampler2D _DetailTex;

		void surf(Input IN,inout SurfaceOutput o){
			o.Albedo=tex2D(_MainTex,IN.uv_MainTex).rgb;
			float2 uv=IN.screenPos.xy/IN.screenPos.w;
             uv*=float2(1.6,1);
			o.Albedo*=tex2D(_DetailTex,uv).rgb*2;
			o.Normal=UnpackNormal(tex2D(_BumpTex,IN.uv_BumpTex));
		}
		ENDCG
	}

}
