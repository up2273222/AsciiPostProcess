


using System.Collections;
using System.Collections.Generic;
using System.IO;
using Unity.VisualScripting;
using UnityEditor;
using UnityEngine;



public class ImageSaver : MonoBehaviour
{
    public string filePath = @"E:\";
    
    public PostProcessor postProcessor;
    
    public RTToFile.SaveTextureFileFormat format;
    public string fileName;

    public static string GetUniqueFilePath(string filePath, string fileName, string extension)
    {
        string path = Path.Combine(filePath, fileName);
        
        int counter = 1;
        
        while (File.Exists(new string(path + extension)))
        {   
            string newFileName = $"{fileName}({counter})";
            path = Path.Combine(filePath, newFileName);
            counter++;
        }

        return path;
    }

    public string GetFileExtension()
    {
        switch (format)
        {
            case RTToFile.SaveTextureFileFormat.EXR:
                return ".exr";
               
            case RTToFile.SaveTextureFileFormat.JPG:
                return ".jpg";
           
            case RTToFile.SaveTextureFileFormat.PNG:
                return ".png";
              
            case RTToFile.SaveTextureFileFormat.TGA:
                return ".tga";
        }
        return "";
    }
    
    
}



[CustomEditor(typeof(ImageSaver))]
    class ImageSaverEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();
            ImageSaver imageSaver = (ImageSaver)target;
            if (GUILayout.Button("Save current result as image"))
            {
                if (!imageSaver.postProcessor.GetResultTexture())
                {
                    Debug.Log("Result is null");
                    return;
                }
               string file = ImageSaver.GetUniqueFilePath(imageSaver.filePath, imageSaver.fileName, imageSaver.GetFileExtension());
               RTToFile.SaveRenderTextureToFile(imageSaver.postProcessor.GetResultTexture(),file,imageSaver.format);
               Debug.Log("File saved to " + file);
                
            }
        }
    }



