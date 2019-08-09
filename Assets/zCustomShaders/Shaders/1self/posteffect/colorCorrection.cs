using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class colorCorrection : MonoBehaviour {
    public AnimationCurve rc,gc,bc;
    private Material mat;
    private Texture2D rgbTex;
    public Shader shader;
	// Use this for initialization
	void Start () {
        mat = new Material ( shader );
        rgbTex = new Texture2D ( 256, 4, TextureFormat.ARGB32, false );
        rgbTex.hideFlags = HideFlags.HideAndDontSave;
        rgbTex.wrapMode = TextureWrapMode.Clamp;
	}
	
	// Update is called once per frame
	void Update () {
        for ( float i = 0; i < 1; i+=1/255f )
            {
            float rch=Mathf.Clamp01(rc.Evaluate(i));
            float gch=Mathf.Clamp01(gc.Evaluate(i));
            float bch=Mathf.Clamp01(bc.Evaluate(i));
            rgbTex.SetPixel ( Mathf.FloorToInt ( i * 255 ), 0, new Color ( rch, rch, rch ) );
            rgbTex.SetPixel ( Mathf.FloorToInt ( i * 255 ), 1, new Color ( gch, gch, gch ) );
            rgbTex.SetPixel ( Mathf.FloorToInt ( i * 255 ), 2, new Color ( bch, bch, bch ) );
            rgbTex.Apply ( );
            }        
		
	}

    private void OnRenderImage ( RenderTexture source, RenderTexture destination )
        {
        mat.SetTexture ( "rgbtex", rgbTex );
        Graphics.Blit ( source,destination, mat );
        }
    }
