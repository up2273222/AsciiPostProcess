using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PostProcessor : MonoBehaviour
{
    public Material asciiPostProcessMaterial;
    public Material asciiImageMaterial;
    public Texture2D image;
    public bool usePostProcess;

    public float brightness;
    public int cellSize;

    private RenderTexture result;



    private void OnRenderImage(RenderTexture source, RenderTexture destination)
 {
     if (usePostProcess)
     {
         asciiPostProcessMaterial.SetFloat("_cellSize", cellSize);
         Graphics.Blit(source, destination,asciiPostProcessMaterial);
         
     }
     else
     {
         if (result == null)
         {
             result = RenderTexture.GetTemporary(image.width, 
                                                image.height,
                                                 0,
                                              source.format);
         }
     
     
         asciiImageMaterial.SetTexture("_MainTex", image);
         asciiImageMaterial.SetFloat("_imageWidth",image.width);
         asciiImageMaterial.SetFloat("_imageHeight", image.height);
         asciiImageMaterial.SetFloat("_brightness", brightness);
         asciiImageMaterial.SetFloat("_cellSize", cellSize);
         Graphics.Blit(image, result, asciiImageMaterial);
         Graphics.Blit(result, destination);

     }
   
 }
 
 public RenderTexture GetResultTexture()
 {
    return result;
 }
}


