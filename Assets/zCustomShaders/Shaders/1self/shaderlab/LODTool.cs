using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class LODTool : MonoBehaviour {
    public Shader shader;
    public int myShaderValue;
    public int globalValue;

  //设置特定lod值的不受global影响,没设置特定值的受global影响,从上至下,选取一个小于当前值的最大值的subshader
	void Update () {
        shader.maximumLOD = myShaderValue * 100;
        Shader.globalMaximumLOD = globalValue * 100;
	}
}
