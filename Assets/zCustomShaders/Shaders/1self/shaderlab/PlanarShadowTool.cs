using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class PlanarShadowTool : MonoBehaviour {

    public Transform reciever;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        GetComponent<Renderer> ( ).sharedMaterial.SetMatrix ( "_world2ground", reciever.worldToLocalMatrix );
        GetComponent<Renderer> ( ).sharedMaterial.SetMatrix ( "_ground2world", reciever.localToWorldMatrix );
        }
}
