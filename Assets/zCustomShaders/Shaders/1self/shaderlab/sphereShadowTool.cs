using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class sphereShadowTool : MonoBehaviour {

    public Transform sphere;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        GetComponent<Renderer> ( ).sharedMaterial.SetFloat ( Shader.PropertyToID( "sphereR" ), sphere.localScale.x/2 );
        GetComponent<Renderer> ( ).sharedMaterial.SetVector ( "spherePos", sphere.position );
        }
}
