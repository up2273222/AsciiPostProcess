Shader "Unlit/Sobel"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _edgeThreshold("Edge Threshold",Float) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Blend Off
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

            Texture2D _MainTex;
            SamplerState sampler_MainTex;
            
            float _edgeThreshold;


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
            
            

            float4 frag (v2f i) : SV_Target
            {
                float4 pixelCol = _MainTex.Sample(sampler_MainTex, i.uv);
                
                float xSum = 0;
                xSum = Luminance(_MainTex.Sample(sampler_MainTex,getUvOffset(i.uv,float2(-1,-1)))) * 1;
                xSum += Luminance(_MainTex.Sample(sampler_MainTex,getUvOffset(i.uv,float2(-1,0)))) * 2;
                xSum += Luminance(_MainTex.Sample(sampler_MainTex,getUvOffset(i.uv,float2(-1,1)))) * 1;
                
                xSum += Luminance(_MainTex.Sample(sampler_MainTex,getUvOffset(i.uv,float2(1,1)))) * -1;
                xSum += Luminance(_MainTex.Sample(sampler_MainTex,getUvOffset(i.uv,float2(1,0)))) * -2;
                xSum += Luminance(_MainTex.Sample(sampler_MainTex,getUvOffset(i.uv,float2(1,-1)))) * -1;
                
                float ySum = 0;
                ySum = Luminance(_MainTex.Sample(sampler_MainTex,getUvOffset(i.uv,float2(-1,-1)))) * -1;
                ySum += Luminance(_MainTex.Sample(sampler_MainTex,getUvOffset(i.uv,float2(0,-1)))) * -2;
                ySum += Luminance(_MainTex.Sample(sampler_MainTex,getUvOffset(i.uv,float2(1,-1)))) * -1;
                
                ySum += Luminance(_MainTex.Sample(sampler_MainTex,getUvOffset(i.uv,float2(-1,1)))) * 1;
                ySum += Luminance(_MainTex.Sample(sampler_MainTex,getUvOffset(i.uv,float2(0,1)))) * 2;
                ySum += Luminance(_MainTex.Sample(sampler_MainTex,getUvOffset(i.uv,float2(1,1)))) * 1;
                
   

                //return float4(xSum * xSum,ySum * ySum,0,1);
                
               // float mag = sqrt((xSum * xSum) + (ySum * ySum));
               float mag = abs(xSum) + abs(ySum);
                if (mag > _edgeThreshold)
                {
                   return float4(0,0,0,1);
                }
                   return float4(xSum * xSum,ySum * ySum,0,1);
                    
                    
                
                
                
                
  
 
                
                
                
                return float4(i.uv,0,1);
            }
            ENDCG
        }
    }
}
