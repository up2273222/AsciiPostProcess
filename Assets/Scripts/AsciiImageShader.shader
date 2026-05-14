Shader "Unlit/AsciiImage"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _AsciiTilesetTex("Ascii Tileset Texture", 2D) = "white" {}
        _cellSize("Cell size", Range(1,256)) = 256
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }


        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            Texture2D _MainTex, _AsciiTilesetTex;
            SamplerState sampler_MainTex;
            SamplerState sampler_AsciiTilesetTex;
            float _cellSize, _testValue;
            float _imageWidth,_imageHeight;
            float _brightness;
            
            


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            float mod(float x, float y)
            {
                return x - y * floor(x/y);
            }

            float4 frag (v2f i) : SV_Target
            {
                //Pixellate
                float2 imageSize = float2(_imageWidth,_imageHeight);
                _cellSize = (int)_cellSize;
                float2 ScreenUV = ((floor(i.uv * imageSize.xy/_cellSize) * _cellSize) + _cellSize * 0.5f) /imageSize.xy;
                
                //Get luminance value
                float3 pixelColor = _MainTex.Sample(sampler_MainTex,ScreenUV).xyz ;
                float luminance = Luminance(pixelColor * _brightness);
               // luminance = floor(luminance * 10)/10;
                luminance = max(0, (floor(luminance * 10) - 1 )) / 10.0f;
                if (luminance > 0.9) {luminance = 0.9;}
               //if (luminance < 0.0) {luminance = 0.0;}
          
                
               
      


             
              
                
                
                
                //Read from tileset
                float2 cellUV = frac(i.uv * imageSize.xy / _cellSize);
                float2 tilesetUV = float2(luminance + cellUV.x * 0.1f, cellUV.y);
          
                float2 asciiUv;
                asciiUv.x = ((i.uv.x % _cellSize) + (luminance * 80.f));
                asciiUv.y = ((i.uv.y % _cellSize));
       
 
                
              //  float3 asciiCol = _AsciiTilesetTex.Sample(sampler_AsciiTilesetTex,tilesetUV);
                float3 asciiCol = _AsciiTilesetTex.Sample(sampler_AsciiTilesetTex,asciiUv) * _MainTex.Sample(sampler_MainTex,i.uv);
                
                //float3 finalCol = pow(asciiCol, 1.0/2.2);
                
                return float4(asciiCol,1.0);
               
                

                 
                
                return float4(ScreenUV,0,1);
            }
            ENDCG
        }
       





    }
}
    