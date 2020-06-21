using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class sunContro : MonoBehaviour {

    [Range(10,100)]
    public int iterations=50;
	// Use this for initialization
	void Start () {
        Cursor.visible = false;
	}
	
	// Update is called once per frame
	void Update () {
        Shader.SetGlobalVector("mouse", Input.mousePosition);
        Shader.SetGlobalInt("iteration", iterations);
	}
}
