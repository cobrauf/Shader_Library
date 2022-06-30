// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/A_TextureManipulation/PatternFill"
{
	Properties
	{
		_MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		_Pattern("Pattern", 2D) = "white" {}
		_TintColor("TintColor", Color) = (0,0,0,0)
		_Fade("Fade", Range( 0 , 1)) = 0.4087379
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_EdgeColor("EdgeColor", Color) = (0.8867924,0.6656958,0.1547704,0)
		_EdgeWidth("EdgeWidth", Range( 0.8 , 1)) = 0.8
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}
	
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		Cull Off

		
		Pass
		{
			CGPROGRAM
			#pragma target 3.0 
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};

			uniform sampler2D _MainTex;
			uniform fixed4 _Color;
			uniform sampler2D _Pattern;
			uniform float4 _Pattern_ST;
			uniform sampler2D _TextureSample1;
			uniform float4 _TextureSample1_ST;
			uniform float _Fade;
			uniform float4 _TintColor;
			uniform float _EdgeWidth;
			uniform float4 _EdgeColor;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.texcoord.xy = v.texcoord.xy;
				o.texcoord.zw = v.texcoord1.xy;
				
				// ase common template code
				
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				fixed4 myColorVar;
				// ase common template code
				float2 uv_Pattern = i.texcoord.xy * _Pattern_ST.xy + _Pattern_ST.zw;
				float4 tex2DNode1 = tex2D( _Pattern, uv_Pattern );
				float4 color12 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float2 uv_TextureSample1 = i.texcoord.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
				float lerpResult13 = lerp( color12.r , tex2D( _TextureSample1, uv_TextureSample1 ).r , _Fade);
				
				
				myColorVar = ( ( ( tex2DNode1.r * ( 1.0 - step( lerpResult13 , 0.1 ) ) ) * _TintColor ) + ( tex2DNode1.r * ( ( step( ( lerpResult13 * _EdgeWidth ) , 0.1 ) * ( 1.0 - step( ( lerpResult13 * 1.0 ) , 0.1 ) ) ) * _EdgeColor ) ) );
				return myColorVar;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
0;73;1671;1286;1739.246;838.7448;1.3;True;False
Node;AmplifyShaderEditor.ColorNode;12;-1946.845,-367.9004;Float;False;Constant;_Color0;Color 0;4;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-1941.644,31.20066;Float;False;Property;_Fade;Fade;3;0;Create;True;0;0;False;0;0.4087379;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-1991.045,-181.9993;Float;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;None;bd46706ff72992a4c8a07db09bba3dce;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;13;-1568.543,-306.8001;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1716.237,439.5465;Float;False;Constant;_BorderAdjust;BorderAdjust;5;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1720.139,282.2471;Float;False;Property;_EdgeWidth;EdgeWidth;6;0;Create;True;0;0;False;0;0.8;0.9;0.8;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1334.037,456.4465;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;27;-1064.938,494.1465;Float;True;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1331.437,173.0466;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;28;-833.5362,499.3467;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;22;-1076.638,248.447;Float;True;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;16;-1099.343,-171.4978;Float;True;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1119.438,-567.7627;Float;True;Property;_Pattern;Pattern;0;0;Create;True;0;0;False;0;None;0f386139854bb204ea90d0687c4a664c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-643.7366,236.7468;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;18;-824.9424,-154.6976;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;24;-647.6365,500.6473;Float;False;Property;_EdgeColor;EdgeColor;5;0;Create;True;0;0;False;0;0.8867924,0.6656958,0.1547704,0;0.8867924,0.6656958,0.1547704,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-382.437,234.147;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;3;-278.3376,-523.5624;Float;False;Property;_TintColor;TintColor;1;0;Create;True;0;0;False;0;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-468.7427,-70.19719;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-22.33695,76.84686;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-31.33749,-198.5625;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1262.437,-358.4626;Float;False;Property;_StepValue;StepValue;2;0;Create;True;0;0;False;0;0.99;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;9;-953.1368,-308.1627;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;223.3632,22.24692;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;4;-754.8373,-693.3624;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;475.4998,-257.4;Float;False;True;2;Float;ASEMaterialInspector;0;3;ASE/A_TextureManipulation/PatternFill;6e114a916ca3e4b4bb51972669d463bf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;RenderType=Opaque=RenderType;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;13;0;12;1
WireConnection;13;1;11;1
WireConnection;13;2;14;0
WireConnection;25;0;13;0
WireConnection;25;1;26;0
WireConnection;27;0;25;0
WireConnection;20;0;13;0
WireConnection;20;1;21;0
WireConnection;28;0;27;0
WireConnection;22;0;20;0
WireConnection;16;0;13;0
WireConnection;30;0;22;0
WireConnection;30;1;28;0
WireConnection;18;0;16;0
WireConnection;23;0;30;0
WireConnection;23;1;24;0
WireConnection;15;0;1;1
WireConnection;15;1;18;0
WireConnection;31;0;1;1
WireConnection;31;1;23;0
WireConnection;2;0;15;0
WireConnection;2;1;3;0
WireConnection;9;0;6;0
WireConnection;32;0;2;0
WireConnection;32;1;31;0
WireConnection;4;0;1;1
WireConnection;4;1;9;0
WireConnection;0;0;32;0
ASEEND*/
//CHKSM=B8AD61B93C20CE57810610AA8F0FB40887187338