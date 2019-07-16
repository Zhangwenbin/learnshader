using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class test : MonoBehaviour {

    public Camera mcamera;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        var vp=mcamera.projectionMatrix*mcamera.worldToCameraMatrix;
        var ivp=vp.inverse;
       // Debug.LogError ( vp.MultiplyPoint ( transform.position ) );


    }
}
