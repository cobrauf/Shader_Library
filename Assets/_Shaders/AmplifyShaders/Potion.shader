// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/A_Misc/Potion"
{
	Properties
	{
		_HeightAdjust("Height Adjust", Float) = 0.1
		_LiquidColor("Liquid Color", Color) = (1,0,0,0)
		_FallOff("FallOff", Range( 0 , 1)) = 0.05
		_Opacity("Opacity", Range( 0 , 1)) = 0.8
		_WaveSize("Wave Size", Float) = 0.5
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Pass
		{
			ColorMask 0
			ZWrite On
		}

		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		ZWrite On
		ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _WaveSize;
		uniform float _HeightAdjust;
		uniform float _FallOff;
		uniform float _Opacity;
		uniform float4 _LiquidColor;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float mulTime15 = _Time.y * 4.0;
			float4 transform2 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 ase_worldPos = i.worldPos;
			float4 temp_output_4_0 = ( transform2 - float4( ase_worldPos , 0.0 ) );
			float4 clampResult23 = clamp( ( ( ( ( sin( mulTime15 ) * _WaveSize * temp_output_4_0 ) + (temp_output_4_0).y ) + _HeightAdjust ) / _FallOff ) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			c.rgb = _LiquidColor.rgb;
			c.a = ( clampResult23 * _Opacity ).x;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16800
8;100;1160;1030;501.849;284.4993;1.285623;True;False
Node;AmplifyShaderEditor.RangedFloatNode;16;-1511.218,-337.2152;Float;False;Constant;_WaveSpeed;Wave Speed;2;0;Create;True;0;0;False;0;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;24;-1499.109,6.139614;Float;False;787;417.1;Outputs a value for each fragment relative to the object center  top is neg bottom is pos;4;5;4;3;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-1294.116,-329.4155;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;3;-1449.109,248.1397;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;2;-1449.109,56.13961;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;17;-1067.915,-283.9155;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;4;-1193.109,56.13961;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1150.777,-193.3745;Float;False;Property;_WaveSize;Wave Size;5;0;Create;True;0;0;False;0;0.5;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;5;-1001.109,56.13961;Float;False;False;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-892.9947,-295.703;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-591.9026,233.1805;Float;False;Property;_HeightAdjust;Height Adjust;1;0;Create;True;0;0;False;0;0.1;-0.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-611.0461,-22.01355;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-316.2906,69.44645;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-353.6606,220.9265;Float;False;Property;_FallOff;FallOff;3;0;Create;True;0;0;False;0;0.05;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;20;-15.93903,60.90189;Float;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;19;109.0107,380.7763;Float;False;Property;_Opacity;Opacity;4;0;Create;True;0;0;False;0;0.8;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;23;243.92,196.8584;Float;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;1;396.0185,502.0031;Float;False;Property;_LiquidColor;Liquid Color;2;0;Create;True;0;0;False;0;1,0,0,0;0,0.3793104,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;430.9454,304.9712;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;633.6683,215.9797;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;ASE/A_Misc/Potion;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;1;False;-1;7;False;-1;False;0;False;-1;0;False;-1;True;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;16;0
WireConnection;17;0;15;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;5;0;4;0
WireConnection;14;0;17;0
WireConnection;14;1;13;0
WireConnection;14;2;4;0
WireConnection;12;0;14;0
WireConnection;12;1;5;0
WireConnection;26;0;12;0
WireConnection;26;1;10;0
WireConnection;20;0;26;0
WireConnection;20;1;21;0
WireConnection;23;0;20;0
WireConnection;18;0;23;0
WireConnection;18;1;19;0
WireConnection;0;9;18;0
WireConnection;0;13;1;0
ASEEND*/
//CHKSM=6EDE20130C7009F5997A946EE06BBA706BA95E45