Shader "vladimir/cells"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _CellNumber ("Cell Number", Range(1, 20)) = 2
        _Color1 ("Color 1", Color) = (1,1,1,1)
        _Color2 ("Color 2", Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows
        #pragma enable_d3d11_debug_symbols

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        fixed _CellNumber;
        fixed4 _Color1;
        fixed4 _Color2;

        struct Input
        {
            float2 uv_MainTex;
        };

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed2 uv = IN.uv_MainTex;

            int number = int(_CellNumber);
            fixed frame_x = uv.x * number;
            fixed frame_y = uv.y * number;

            int x_even = 1 - int(frame_x%2); // 0 when col is even and 1 when doesn't
            int y_even = 1 - int(frame_y%2); // 0 when row is even and 1 when doesn't

            bool is_even = !(x_even ^ y_even); 
            fixed4 color1 = is_even * _Color1;
            fixed4 color2 = !is_even * _Color2;

            fixed4 color = color1 + color2;
            fixed4 c = tex2D (_MainTex, uv) * color;
            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
