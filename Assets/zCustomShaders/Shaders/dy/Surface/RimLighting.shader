Shader "Custom/RimLighting" {
    Properties{
		_MainTex("tex",2D)="white"{}
		_BumpTex("bump",2D)="white"{}
		_RimColor("rimcolor",Color)=(1,1,1,1)
		_RimPower("rimpower",Range(0,5))=3
	}
	SubShader{
        CGPROGRAM
		#pragma surface surf Lambert 
        struct Input{
			float2 uv_MainTex;
			float2 uv_BumpTex;
			float3 viewDir;
		};

		sampler2D _MainTex;
		sampler2D _BumpTex;
		float4 _RimColor;
		float _RimPower;

	
		void surf(Input IN,inout SurfaceOutput o){
			o.Albedo=tex2D(_MainTex,IN.uv_MainTex).rgb;
			o.Normal=UnpackNormal(tex2D(_BumpTex,IN.uv_BumpTex));
            float rim=1- saturate(dot(normalize(IN.viewDir),o.Normal));
			o.Emission=_RimColor.rgb*pow(rim,_RimPower);

		}
		ENDCG
	}

}
