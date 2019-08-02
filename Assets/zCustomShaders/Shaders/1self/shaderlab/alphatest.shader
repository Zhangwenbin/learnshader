Shader "zwb/shaderlab/alphatest"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MainTex2 ("Texture", 2D) = "white" {}
		_cutoff("cut",Range(0,1))=0
	
	}
	
			SubShader
	{
		Pass
		{
			AlphaTest Always 0
           SetTexture [_MainTex] {combine texture}
		}
		Pass
		{
			AlphaTest Greater [_cutoff]
           SetTexture [_MainTex2] {combine texture}
		}
	}


}
