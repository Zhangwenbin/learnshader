Shader "zwb/shaderlab/lod1"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TinColor("color",Color)=(1,1,1,1)
	
	}

		SubShader
	{
         LOD 400
		Pass
		{
	       Material{Diffuse(1,0,0,1)}
		   Lighting on

		}
	}
	SubShader
	{
         LOD 500
		Pass
		{
	       Material{Diffuse(0,1,0,1)}
		   Lighting on

		}
	}


				SubShader
	{
         LOD 600
		Pass
		{
	       Material{Diffuse(0,0,1,1)}
		   Lighting on

		}
	}
}
