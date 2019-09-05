Shader "Custom/PlanarMapping"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
	SubShader{
		//the material is completely non-transparent and is rendered at the same time as the other opaque geometry
		Tags{ "RenderType" = "Opaque" "Queue" = "Geometry"}

		Pass{
			CGPROGRAM

			//include useful shader functions
			#include "UnityCG.cginc"

			//define vertex and fragment shader
			#pragma vertex vert
			#pragma fragment frag

			//texture and transforms of the texture
			sampler2D _MainTex;
			float4 _MainTex_ST;

			//tint of the texture
			fixed4 _Color;

			
			//the object data that's put into the vertex shader
			struct appdata {
				float4 vertex : POSITION;
			};



			//the data that's used to generate fragments and can be read by the fragment shader
			struct v2f {
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			//the vertex shader
			v2f vert(appdata v) {
				v2f o;
				//convert the vertex positions from object space to clip space so they can be rendered
				o.position = UnityObjectToClipPos(v.vertex);
				//calculate world position of vertex
				float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
				//change UVs based on tiling and offset of texture
				o.uv = TRANSFORM_TEX(worldPos.xz, _MainTex);
				return o;
			}

			//the fragment shader
			fixed4 frag(v2f i) : SV_TARGET{
				fixed4 col = tex2D(_MainTex, i.uv);
				col *= _Color;
				return col;
			}

			ENDCG
		}
	}
	FallBack "Standard" //fallback adds a shadow pass so we get shadows on other objects
}
