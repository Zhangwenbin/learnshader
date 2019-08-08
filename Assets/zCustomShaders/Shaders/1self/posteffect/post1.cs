using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class post1 : MonoBehaviour {

    public RenderTexture dstrt;
    public Material mat;
    public Material displaymat;
    private void Start ( )
        {
        dstrt = new RenderTexture ( Screen.width, Screen.height, 16 );
        displaymat.mainTexture = dstrt;

        }
    private void OnRenderImage ( RenderTexture source, RenderTexture destination )
        {
        Graphics.Blit ( source, dstrt, mat );
        Graphics.Blit ( dstrt, destination );
        }
    }
