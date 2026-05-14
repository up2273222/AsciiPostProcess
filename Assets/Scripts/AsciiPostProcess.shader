Shader "Unlit/AsciiPostProcess"
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
        


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                //Pixellate
                _cellSize = (int)_cellSize;
                float2 ScreenUV = ((floor(i.uv * _ScreenParams.xy/_cellSize) * _cellSize) + _cellSize * 0.5f) /_ScreenParams.xy;
                
                //Get luminance value
                float3 pixelColor = _MainTex.Sample(sampler_MainTex,ScreenUV).xyz;
                float luminance = Luminance(pixelColor);
                luminance = max(0, (floor(luminance * 10) - 1 )) / 10.0f;
                if (luminance > 0.9) {luminance = 0.9;}
                
                //Read from tileset
                float2 cellUV = frac(i.uv * _ScreenParams.xy / _cellSize);
                float2 tilesetUV = float2(luminance + cellUV.x * 0.1f, cellUV.y);
                
                return _AsciiTilesetTex.Sample(sampler_AsciiTilesetTex,tilesetUV) * _MainTex.Sample(sampler_MainTex,ScreenUV);

                 
                
                return float4(ScreenUV,0,1);
            }
            ENDCG
        }
       





    }
}
    