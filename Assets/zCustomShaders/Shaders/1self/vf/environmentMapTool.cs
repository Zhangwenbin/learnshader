using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class environmentMapTool : MonoBehaviour {

    private Renderer target;
    private RenderTexture renderTex;

	// Use this for initialization
	void Start () {
        target = GetComponentInChildren<Renderer> ( );
    }
	
	// Update is called once per frame
	void LateUpdate ( ) {
        if ( target )
            {
            if ( !renderTex )
                {
                renderTex = new RenderTexture ( 1024, 1024, 16 );
                renderTex.dimension = UnityEngine.Rendering.TextureDimension.Cube;
                renderTex.hideFlags = HideFlags.DontSave;
                }
            Camera camera=GetComponent<Camera>();
            if ( !camera )
                {
                camera = gameObject.AddComponent<Camera> ( );
             
                }
            camera.RenderToCubemap ( renderTex, 63 );
            target.sharedMaterial.SetTexture ( "environmentMap", renderTex );
            }
       
	}
   
    }
