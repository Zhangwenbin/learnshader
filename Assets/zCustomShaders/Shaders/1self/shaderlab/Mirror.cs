using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Mirror : MonoBehaviour {
    public Camera mirrorCam;
    public RenderTexture rtex;
    public Matrix4x4 mat;

    private void Awake ( )
        {
        mirrorCam = new GameObject ("mirror came" ).AddComponent<Camera>();
        rtex = new RenderTexture ( 512, 512, 16, RenderTextureFormat.ARGB32 );
        }

    private void OnWillRenderObject ( )
        {
        mirrorCam.CopyFrom ( Camera.main );
        mirrorCam.transform.parent = transform;
        Camera.main.transform.parent = transform;
        var pos=mirrorCam.transform.localPosition;
        pos.y *= -1;
        mirrorCam.transform.localPosition = pos;
        var rt=Camera.main.transform.localEulerAngles;
        Camera.main.transform.parent = null;
        mirrorCam.transform.localEulerAngles = new Vector3 ( -rt.x, rt.y, -rt.z );

        mirrorCam.targetTexture = rtex;
        mirrorCam.cullingMask = ~( 1 << 4 );
        mirrorCam.Render ( );
        Proj ( );
        GetComponent<MeshRenderer> ( ).material.SetMatrix ( "projmat", mat );
        }

    private void Update ( )
        {
        GetComponent<MeshRenderer> ( ).material.SetTexture ( "reftex", rtex );
        }

    void Proj ( )
        {
        mat = GL.GetGPUProjectionMatrix(mirrorCam.projectionMatrix, false) * mirrorCam.worldToCameraMatrix;

        }
    }
