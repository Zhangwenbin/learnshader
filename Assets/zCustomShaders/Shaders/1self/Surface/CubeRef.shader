Shader "Custom/CubeRef" {
    Properties{
		_MainTex("tex",2D)="white"{}
		_Bump("bump",2D)="white"{}
		_Cube("cube",Cube)=""{}
		mn("main",float)=1
		bp("bp",float)=1
        cb("cb",float)=1
	}
	SubShader{
        CGPROGRAM
		#pragma surface surf Lambert
        struct Input{
			float2 uv_MainTex;
			float2 uv_Bump;
			float3 worldRefl;
			INTERNAL_DATA
		};

		sampler2D _MainTex;
		sampler2D _Bump;
		samplerCUBE _Cube;
		float mn;
		float bp;
		float cb;

		void surf(Input IN,inout SurfaceOutput o){
			o.Albedo=tex2D(_MainTex,IN.uv_MainTex).rgb*mn;
			o.Normal=UnpackNormal(tex2D(_Bump,IN.uv_Bump)).rgb*bp;
			o.Emission=texCUBE(_Cube,IN.worldRefl).rgb*cb;
		}
		ENDCG
	}

}
