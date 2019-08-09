using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class tap2 : MonoBehaviour {

    public float offsetx,offsety;
    public Material mat;
	// Use this for initialization
	void Start () {
		
	}

    private void OnRenderImage ( RenderTexture source, RenderTexture destination )
        {
        Graphics.BlitMultiTap ( source, destination, mat,new Vector2( offsetx, offsety ));
        }


    }
