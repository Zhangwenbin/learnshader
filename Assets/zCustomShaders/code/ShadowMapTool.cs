using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShadowMapTool : MonoBehaviour {
    private Camera mcamera;
    private RenderTexture rt;
    Matrix4x4 gm;

    // Use this for initialization
    void Start () {
        mcamera = GetComponent<Camera> ( );

        if ( !rt )
            {
            rt = new RenderTexture ( 1024, 1024, 24 );
            rt.hideFlags = HideFlags.DontSave;
            rt.filterMode = FilterMode.Bilinear;
            rt.useMipMap = false;
          //  rt.format = RenderTextureFormat.Shadowmap;
            rt.wrapMode = TextureWrapMode.Clamp;
            }
        mcamera.targetTexture = rt;
        gm.SetRow ( 0, new Vector4 ( 0.5f, 0   , 0, 0.5f ) );
        gm.SetRow ( 1, new Vector4 ( 0   , 0.5f, 0, 0.5f ) );
        gm.SetRow ( 2, new Vector4 ( 0   , 0, 1   , 0 ) );
        gm.SetRow ( 3, new Vector4 ( 0f  , 0, 0   , 1 ) );

        mcamera.SetReplacementShader ( Shader.Find ( "zwb/vf/depthTexture" ), "RenderType" );
        }
	
	// Update is called once per frame
	void Update () {
         
        mcamera.Render ( );
        Shader.SetGlobalTexture ( "depthTex", rt );
        Matrix4x4 tm = GL.GetGPUProjectionMatrix(mcamera.projectionMatrix, false) * mcamera.worldToCameraMatrix;
        tm = gm * tm;
        Shader.SetGlobalMatrix ( "shadowMatrix", mcamera.worldToCameraMatrix );
        }
    

    
}
