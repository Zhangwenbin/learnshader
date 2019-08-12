using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class postCommon : MonoBehaviour {

    public Shader shader;

    private Material mat;
    private Camera _camera;

    public int offset;

    public float dis;

    public Transform focus;

    private void OnEnable ( )
        {
        _camera = GetComponent<Camera> ( );
        if ( mat==null )
            {
            mat = new Material ( shader );
            }
        _camera.depthTextureMode = DepthTextureMode.Depth;
        }

    private void OnRenderImage ( RenderTexture source, RenderTexture destination )
        {
        mat.SetInt ( "offset", offset );
        dis = Mathf.Clamp ( dis, _camera.nearClipPlane, _camera.farClipPlane );
        mat.SetFloat ( "dis", dis/(_camera.farClipPlane-_camera.nearClipPlane ));
        RenderTexture rt=new RenderTexture(Screen.width,Screen.height,16);
        Graphics.Blit ( source, destination, mat );

        }

    private void Update ( )
        {
        Vector3 target=_camera.worldToCameraMatrix.MultiplyPoint(focus.position);
        dis =Mathf.Abs(target.z);
        Debug.Log ( dis / ( _camera.farClipPlane - _camera.nearClipPlane ) );
        }


    }
