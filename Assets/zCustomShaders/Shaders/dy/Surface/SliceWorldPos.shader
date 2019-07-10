Shader "Custom/SliceWorldPos" {
    Properties{
		_MainTex("tex",2D)="white"{}
		_BumpTex("bump",2D)="white"{}
		_ClipParm1("_Clip Parm1" ,Range(0.0,5.0))=0.1
		_ClipParm2("_Clip Parm2" ,Range(0.0,20.0))=5
		_ClipParm3("_Clip Parm3" ,Range(0.0,5.0))=0.5
	}
	SubShader{
        CGPROGRAM
		#pragma surface surf Lambert
        struct Input{
			float2 uv_MainTex;
			float2 uv_BumpTex;
			float3 worldPos;
		};

		sampler2D _MainTex;
		sampler2D _BumpTex;
	    float _ClipParm1;
		float _ClipParm2;
		float _ClipParm3;
		void surf(Input i,inout SurfaceOutput o){
			clip(frac((i.worldPos.y+i.worldPos.z*_ClipParm1)*_ClipParm2)-_ClipParm3);
			o.Albedo=tex2D(_MainTex,i.uv_MainTex).rgb;
			o.Normal=UnpackNormal(tex2D(_BumpTex,i.uv_BumpTex));
		}
		ENDCG
	}

}
