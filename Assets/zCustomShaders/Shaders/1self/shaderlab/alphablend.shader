Shader "zwb/shaderlab/alphablend"
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
           SetTexture [_MainTex] {combine texture}
		}
		Pass
		{

			// zero one srccolor srcalpha dstcolor dstalpha oneminussrccolor oneminussrcalpha oneminusdstcolor oneminusdstalpha
			//输出= (当前正在计算的颜色)*a+ b*(屏幕已有颜色,缓存颜色)
			Blend zero dstalpha 
           SetTexture [_MainTex2] {combine texture}
		}
	}


}
