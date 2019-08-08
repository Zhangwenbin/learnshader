using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class test : MonoBehaviour {

    public Vector3 pos;
    public Quaternion rotation;
    public Vector3 scale;

    public Vector3 target;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        rotation = transform.rotation;
        Matrix4x4 m=Matrix4x4.TRS(pos,rotation,scale);
        transform.position = m.MultiplyPoint3x4 ( target );

    }
}
