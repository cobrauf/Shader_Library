// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/A_Dissolve/FractalDissolve"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Telelport("Telelport", Range( -10 , 10)) = 0
		_TeleportOutGradient("Teleport Out Gradient", Range( 0 , 10)) = 0
		[Toggle]_InvertTeleportin("Invert (Teleport in)", Float) = 0
		_TeleportInGradient("Teleport In Gradient", Range( -10 , 0)) = 0
		[HDR]_EmissionColor("Emission Color", Color) = (1,0.05147058,0.05147058,0)
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_VertexOffset("Vertex Offset", Range( -1 , 1)) = 0
		_BandThickness("Band Thickness", Range( 0 , 1)) = 0.5
		_BandFrequency("Band Frequency", Range( 0 , 10)) = 10
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _Telelport;
		uniform float _InvertTeleportin;
		uniform float _TeleportOutGradient;
		uniform float _TeleportInGradient;
		uniform float _VertexOffset;
		uniform float _BandFrequency;
		uniform float _BandThickness;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _EmissionColor;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 transform14 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float Y_Gradient24 = saturate( ( ( transform14.y + _Telelport ) / lerp(_TeleportOutGradient,_TeleportInGradient,_InvertTeleportin) ) );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float NoisePattern23 = step( frac( ( ase_worldPos.y * _BandFrequency ) ) , _BandThickness );
			float3 Y_Offset48 = ( ( ( ase_vertex3Pos * Y_Gradient24 ) * _VertexOffset ) * NoisePattern23 );
			v.vertex.xyz += Y_Offset48;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = tex2D( _Albedo, uv_Albedo ).rgb;
			float3 ase_worldPos = i.worldPos;
			float NoisePattern23 = step( frac( ( ase_worldPos.y * _BandFrequency ) ) , _BandThickness );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform14 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float Y_Gradient24 = saturate( ( ( transform14.y + _Telelport ) / lerp(_TeleportOutGradient,_TeleportInGradient,_InvertTeleportin) ) );
			float4 Emission34 = ( _EmissionColor * NoisePattern23 * Y_Gradient24 );
			o.Emission = Emission34.rgb;
			o.Alpha = 1;
			float temp_output_18_0 = ( 1.0 - Y_Gradient24 );
			float OpacityMask27 = ( temp_output_18_0 + ( temp_output_18_0 * NoisePattern23 ) );
			clip( OpacityMask27 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16800
0;73;1786;1286;464.7437;714.267;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;21;-1452.112,384.0556;Float;False;1104.636;505.7007;Assigns a value according to vertex position (with a gradient at the edge);8;17;15;55;13;14;54;16;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;11;-1479.328,434.8166;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;14;-1243.935,430.1028;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;54;-900.274,864.307;Float;False;Property;_TeleportInGradient;Teleport In Gradient;5;0;Create;True;0;0;False;0;0;-5.23;-10;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-898.874,770.3554;Float;False;Property;_TeleportOutGradient;Teleport Out Gradient;3;0;Create;True;0;0;False;0;0;5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1323.924,617.1877;Float;False;Property;_Telelport;Telelport;2;0;Create;True;0;0;False;0;0;-3.5;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;78;-1073.659,-148.9582;Float;False;1359.529;478.3286;Fractal bands pattern;7;72;62;59;61;23;77;71;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;71;-1012.483,-90.88116;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;77;-1023.659,136.5033;Float;False;Property;_BandFrequency;Band Frequency;13;0;Create;True;0;0;False;0;10;7;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-914.9119,437.7366;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;55;-624.1631,774.4528;Float;False;Property;_InvertTeleportin;Invert (Teleport in);4;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;15;-754.6743,445.7555;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-724.3205,-98.95819;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-528.3739,214.3704;Float;False;Property;_BandThickness;Band Thickness;12;0;Create;True;0;0;False;0;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;59;-425.8749,-44.67786;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;17;-516.2747,447.8556;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;56;-1457.339,1025.932;Float;False;1451.482;553.9756;Vertex Offset;8;45;46;47;51;50;53;52;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;28;-71.6322,425.5285;Float;False;1138.327;526.4685;Opacity Mask;6;41;19;18;26;25;42;;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode;61;-199.9304,25.32204;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-311.1319,430.212;Float;True;Y_Gradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-1405.857,1274.538;Float;True;24;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;45;-1407.339,1075.932;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;42.87062,-37.34155;Float;False;NoisePattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-21.6322,479.3129;Float;True;24;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1095.63,1354.207;Float;False;Property;_VertexOffset;Vertex Offset;11;0;Create;True;0;0;False;0;0;0.5;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1140.559,1098.164;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;18;197.1204,475.5285;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;166.4677,710.1122;Float;False;23;NoisePattern;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;35;-584.0555,-819.8909;Float;False;Property;_EmissionColor;Emission Color;8;1;[HDR];Create;True;0;0;False;0;1,0.05147058,0.05147058,0;0,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;407.3202,572.8278;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-577.6541,-628.1924;Float;True;23;NoisePattern;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-826.4781,1098.856;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-581.0541,-421.1925;Float;True;24;Y_Gradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-810.2934,1349.908;Float;True;23;NoisePattern;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-288.4532,-790.9912;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-525.5834,1103.531;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;648.8646,475.055;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-248.8577,1099.653;Float;False;Y_Offset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-69.45315,-731.0904;Float;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;20;-2673.715,-232.4902;Float;False;1549.806;438.7991;Noise pattern;8;6;4;3;1;9;2;8;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;874.2084,475.448;Float;False;OpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;501.443,63.64325;Float;True;27;OpacityMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;2;-1561.318,-162.9899;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;83;-2374.747,474.0983;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;89;-2344.134,681.2178;Float;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;4;-2137.219,3.410161;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1878.518,-127.8898;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;6;-2336.115,0.8101845;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;523.4573,286.3123;Float;False;48;Y_Offset;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1529.91,91.30965;Float;False;Constant;_Boost;Boost;1;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2623.715,-148.2899;Float;False;Property;_SpeedDirection;Speed/Direction;7;0;Create;True;0;0;False;0;1;3.7;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-2153.134,628.2178;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-1277.91,-95.39063;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;84;-2611.023,462.3638;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;37;446.3901,-347.455;Float;True;Property;_Normal;Normal;10;0;Create;True;0;0;False;0;None;0bebe40e9ebbecc48b8e9cfea982da7e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;85;-2384.721,372.3639;Float;False;Property;_Float0;Float 0;0;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;433.6817,-576.2001;Float;True;Property;_Albedo;Albedo;9;0;Create;True;0;0;False;0;None;b297077dae62c1944ba14cad801cddf5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;82;-1992.045,436.0452;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;3;-2128.119,-182.49;Float;False;Property;_Tiling;Tiling;6;0;Create;True;0;0;False;0;10,10;50,50;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;29;498.3545,-135.8801;Float;True;34;Emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;812.2443,-269.8819;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;ASE/A_Dissolve/FractalDissolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;42;-2.521631,825.1364;Float;False;872.8;100;The noise was too strong, so I had to add more white to it, hence the y_gradient > one minus > add;0;;1,1,1,1;0;0
WireConnection;14;0;11;0
WireConnection;13;0;14;2
WireConnection;13;1;12;0
WireConnection;55;0;16;0
WireConnection;55;1;54;0
WireConnection;15;0;13;0
WireConnection;15;1;55;0
WireConnection;72;0;71;2
WireConnection;72;1;77;0
WireConnection;59;0;72;0
WireConnection;17;0;15;0
WireConnection;61;0;59;0
WireConnection;61;1;62;0
WireConnection;24;0;17;0
WireConnection;23;0;61;0
WireConnection;47;0;45;0
WireConnection;47;1;46;0
WireConnection;18;0;25;0
WireConnection;19;0;18;0
WireConnection;19;1;26;0
WireConnection;50;0;47;0
WireConnection;50;1;51;0
WireConnection;33;0;35;0
WireConnection;33;1;31;0
WireConnection;33;2;32;0
WireConnection;52;0;50;0
WireConnection;52;1;53;0
WireConnection;41;0;18;0
WireConnection;41;1;19;0
WireConnection;48;0;52;0
WireConnection;34;0;33;0
WireConnection;27;0;41;0
WireConnection;2;0;1;0
WireConnection;83;0;84;0
WireConnection;4;1;6;0
WireConnection;1;0;3;0
WireConnection;1;1;4;0
WireConnection;6;0;7;0
WireConnection;88;0;83;2
WireConnection;88;1;89;0
WireConnection;8;0;2;0
WireConnection;8;1;9;0
WireConnection;82;0;85;0
WireConnection;82;3;88;0
WireConnection;82;4;83;2
WireConnection;0;0;36;0
WireConnection;0;1;37;0
WireConnection;0;2;29;0
WireConnection;0;10;30;0
WireConnection;0;11;49;0
ASEEND*/
//CHKSM=35106FB56F37F381A753858272710CC30DDD7538