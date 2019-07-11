Shader "zwb/surface/Extrusion" {
    Properties{
		_MainTex("tex",2D)="white"{}
		_BumpTex("bump",2D)="white"{}
		_Extrusion("extrusion",float)=0
	}
	SubShader{
        CGPROGRAM
		#pragma surface surf Lambert vertex:vert
        struct Input{
			float2 uv_MainTex;
			float2 uv_BumpTex;
		};

		sampler2D _MainTex;
		sampler2D _BumpTex;
		float _Extrusion;

		void vert(inout appdata_full v){
           v.vertex.xyz+=v.normal*_Extrusion;
		}

		void surf(Input IN,inout SurfaceOutput o){
			o.Albedo=tex2D(_MainTex,IN.uv_MainTex).rgb;
			o.Normal=UnpackNormal(tex2D(_BumpTex,IN.uv_BumpTex));
		}
		ENDCG
	}

}
