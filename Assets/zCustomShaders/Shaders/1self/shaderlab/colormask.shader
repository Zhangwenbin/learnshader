Shader "zwb/shaderlab/colormask"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	
	}
	
			SubShader
	{
		
		Tags{"RenderType"="Opaque" "Queue"="Transparent"}

		pass{
			ZWrite on 
			ColorMask 0
		}
		pass{
			ZWrite off
               blend srcalpha oneminussrcalpha
			   ColorMask rgb
			   SetTexture [_MainTex] {Combine texture double}
			   
		}
	
	}


}
