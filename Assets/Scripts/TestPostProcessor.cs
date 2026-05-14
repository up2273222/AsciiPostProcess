using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestPostProcessor: MonoBehaviour
{
    public Material postProcess;
    
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
         Graphics.Blit(source, destination,postProcess);
    }
    

}


