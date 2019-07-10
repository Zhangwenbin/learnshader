Shader "Custom/Ramp" {
    Properties{
		_MainTex("tex",2D)="white"{}
		_BumpTex("bump",2D)="white"{}
		_RampTex("ramp",2D)=""{}
	}
	SubShader{
        CGPROGRAM
		#pragma surface surf ramp
        struct Input{
			float2 uv_MainTex;
			float2 uv_BumpTex;
		};

		sampler2D _MainTex;
		sampler2D _BumpTex;
		sampler2D _RampTex;

		half4 Lightingramp(SurfaceOutput s,float3 ligthDir,float atten){
            float ndotl=dot(s.Normal,ligthDir);
			ndotl=ndotl*0.5+0.5;
			float3 ramp=tex2D(_RampTex,float2(ndotl,ndotl)).rgb;
			half4 color;
			color.rgb=s.Albedo*_LightColor0.rgb*ramp*atten;
			color.a=s.Alpha;
			return color;
		}

		void surf(Input IN,inout SurfaceOutput o){
			o.Albedo=tex2D(_MainTex,IN.uv_MainTex).rgb;
			o.Normal=UnpackNormal(tex2D(_BumpTex,IN.uv_BumpTex));
		}
		ENDCG
	}

}
