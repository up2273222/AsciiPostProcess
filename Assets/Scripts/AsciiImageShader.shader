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
            
            float2 getUvOffset(float2 uv, float2 offset)
            {
                return float2(uv + (float2(offset)/ _ScreenParams.xy));
            }
            
            float2 getCellUvOffset(float2 uv, float2 offset, float cellSize)
            {
                return float2(uv + (float2(offset * cellSize)/ _ScreenParams.xy));
            }
            
            void Sobel(float2 uv,float cellSize, inout float xSum, inout float ySum)
            {
                xSum = Luminance(_MainTex.Sample(sampler_MainTex,getCellUvOffset(uv,float2(-1,-1),cellSize))) * 1;
                xSum += Luminance(_MainTex.Sample(sampler_MainTex,getCellUvOffset(uv,float2(-1,0),cellSize))) * 2;
                xSum += Luminance(_MainTex.Sample(sampler_MainTex,getCellUvOffset(uv,float2(-1,1),cellSize))) * 1;
                
                xSum += Luminance(_MainTex.Sample(sampler_MainTex,getCellUvOffset(uv,float2(1,1),cellSize))) * -1;
                xSum += Luminance(_MainTex.Sample(sampler_MainTex,getCellUvOffset(uv,float2(1,0),cellSize))) * -2;
                xSum += Luminance(_MainTex.Sample(sampler_MainTex,getCellUvOffset(uv,float2(1,-1),cellSize))) * -1;
                

                
                ySum = Luminance(_MainTex.Sample(sampler_MainTex,getCellUvOffset(uv,float2(-1,-1),cellSize))) * -1;
                ySum += Luminance(_MainTex.Sample(sampler_MainTex,getCellUvOffset(uv,float2(0,-1),cellSize))) * -2;
                ySum += Luminance(_MainTex.Sample(sampler_MainTex,getCellUvOffset(uv,float2(1,-1),cellSize))) * -1;
                
                ySum += Luminance(_MainTex.Sample(sampler_MainTex,getCellUvOffset(uv,float2(-1,1),cellSize))) * 1;
                ySum += Luminance(_MainTex.Sample(sampler_MainTex,getCellUvOffset(uv,float2(0,1),cellSize))) * 2;
                ySum += Luminance(_MainTex.Sample(sampler_MainTex,getCellUvOffset(uv,float2(1,1),cellSize))) * 1;
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
                luminance = max(0, (floor(luminance * 10) - 1 )) / 10.0f;
                if (luminance > 0.9) {luminance = 0.9;}
                
                //Sobel
                float xSum = 0.f, ySum = 0.f;
                Sobel(ScreenUV,_cellSize,xSum,ySum);

                
                //Read from tileset
                float2 cellUV = frac(i.uv * imageSize.xy / _cellSize);
                float2 tilesetUV = float2(luminance + cellUV.x * 0.1f, cellUV.y);
                float3 asciiCol = _AsciiTilesetTex.Sample(sampler_AsciiTilesetTex,tilesetUV) * _MainTex.Sample(sampler_MainTex,i.uv);
               // float3 asciiCol = _AsciiTilesetTex.Sample(sampler_AsciiTilesetTex,tilesetUV) * float3(xSum * xSum,ySum * ySum, 0.0f);
                
                
                
           
                
                return float4(asciiCol,1.0);
                return float4(ScreenUV,0,1);
            }
            ENDCG
        }
       





    }
}
    