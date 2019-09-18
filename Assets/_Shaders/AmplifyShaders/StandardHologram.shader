// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Hologram/StandardHologram"
{
	Properties
	{
		_AnimateSpeed("Sin Animate Speed", Float) = 5
		_RimColor("Rim Color", Color) = (1,0,0,0)
		_RimPower("Rim Power", Range( 0 , 10)) = 0
		[Toggle]_Dither("Dither", Float) = 0
		_Opacity("Opacity", Float) = 0.5
		_HologramPattern("HologramPattern", 2D) = "white" {}
		_ShieldColor("Shield Color", Color) = (0.1693339,0.7941176,0.4580271,1)
		_ShieldBrightness("Shield Brightness", Range( 0 , 10)) = 0
		_RimPower("Rim Power", Range( 0 , 5)) = 0
		_WaveEffect("Wave Effect", 2D) = "white" {}
		_WaveSpeed("Wave Speed", Float) = 1
		_Vector0("WaveTiling", Vector) = (1,1,0,0)
		_MainTex("MainTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
			float4 screenPosition;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _RimColor;
		uniform float _RimPower;
		uniform float _AnimateSpeed;
		uniform sampler2D _HologramPattern;
		uniform float4 _HologramPattern_ST;
		uniform float4 _ShieldColor;
		uniform float _ShieldBrightness;
		uniform sampler2D _WaveEffect;
		uniform float2 _Vector0;
		uniform float _WaveSpeed;
		uniform float _Dither;
		uniform float _Opacity;


		inline float Dither8x8Bayer( int x, int y )
		{
			const float dither[ 64 ] = {
				 1, 49, 13, 61,  4, 52, 16, 64,
				33, 17, 45, 29, 36, 20, 48, 32,
				 9, 57,  5, 53, 12, 60,  8, 56,
				41, 25, 37, 21, 44, 28, 40, 24,
				 3, 51, 15, 63,  2, 50, 14, 62,
				35, 19, 47, 31, 34, 18, 46, 30,
				11, 59,  7, 55, 10, 58,  6, 54,
				43, 27, 39, 23, 42, 26, 38, 22};
			int r = y * 8 + x;
			return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			o.screenPosition = ase_screenPos;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float3 temp_cast_0 = (0.0).xxx;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult3_g8 = dot( (WorldNormalVector( i , temp_cast_0 )) , ase_worldViewDir );
			float4 temp_cast_1 = (_RimPower).xxxx;
			float mulTime9_g7 = _Time.y * _AnimateSpeed;
			float2 uv_HologramPattern = i.uv_texcoord * _HologramPattern_ST.xy + _HologramPattern_ST.zw;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV10_g9 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode10_g9 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV10_g9, _RimPower ) );
			float mulTime2_g9 = _Time.y * _WaveSpeed;
			float2 panner3_g9 = ( mulTime2_g9 * float2( 0,-1 ) + float2( 0,0 ));
			float2 uv_TexCoord4_g9 = i.uv_texcoord * _Vector0 + panner3_g9;
			float4 temp_cast_2 = (uv_TexCoord4_g9.y).xxxx;
			float4 transform29_g9 = mul(unity_ObjectToWorld,temp_cast_2);
			float2 temp_cast_3 = (transform29_g9.y).xx;
			float4 WavyEffect7_g9 = tex2D( _WaveEffect, temp_cast_3 );
			o.Emission = ( tex2D( _MainTex, uv_MainTex ) * ( pow( ( ( 1.0 - dotResult3_g8 ) * _RimColor ) , temp_cast_1 ) * (sin( mulTime9_g7 )*0.5 + 0.5) * ( ( tex2D( _HologramPattern, uv_HologramPattern ) + fresnelNode10_g9 ) * _ShieldColor * _ShieldBrightness * WavyEffect7_g9 ) ) ).rgb;
			float4 ase_screenPos = i.screenPosition;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 clipScreen40 = ase_screenPosNorm.xy * _ScreenParams.xy;
			float dither40 = Dither8x8Bayer( fmod(clipScreen40.x, 8), fmod(clipScreen40.y, 8) );
			o.Alpha = lerp(_Opacity,( dither40 * _Opacity ),_Dither);
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
275;171;1279;1030;1239.109;472.188;1.3;True;False
Node;AmplifyShaderEditor.FunctionNode;44;-586.2683,317.3728;Float;False;HologramDY;12;;9;17d9e853558bb1f4e9d4ac56c85a3bf9;0;0;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;46;-594.2303,132.3401;Float;False;RimLightDY;2;;8;afbfcd9a430bf594399009a07eac2aca;0;1;9;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;45;-589.4393,221.5033;Float;False;SinAnimateDY;0;;7;a8becba6639d50943b0d67e4ed8a4d32;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DitheringNode;40;-853.9291,463.2308;Float;False;1;False;3;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-855.415,570.2808;Float;False;Property;_Opacity;Opacity;10;0;Create;True;0;0;False;0;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;23;-1857.11,-221.278;Float;False;732.6006;499.3974;Properties to affect the edge highlight;6;39;37;36;34;32;31;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;17;-2068.037,-523.7966;Float;False;886;278;Custom Map (Ambient Occlusion on Red Channel, Edges-like curvature map on Green Channel);3;35;29;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;52;-455.8016,-159.1054;Float;True;Property;_MainTex;MainTex;20;0;Create;True;0;0;False;0;None;e70a4cc9a27a530468623a76c6c025fe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-336.9245,127.3502;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;10;-3156.541,990.1138;Float;False;907.8201;534.3306;The same lerp for the Top Gradient Colors;4;21;15;13;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;4;-3213.49,-346.9541;Float;False;979.0565;512.1661;Create the world gradient;5;20;16;9;7;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;26;-2180.754,545.7577;Float;False;574.3599;190.4;Lerp the Bottom and Top Colors according to the world gradient;1;30;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1;-3156.746,217.0152;Float;False;901.0599;287.59;Get World Y Vector Mask;4;8;5;3;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;33;-1074.492,-362.7137;Float;False;268.1501;198.07;Combine AO with multiply;1;41;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;42;-784.4042,-117.5789;Float;False;273.22;179.4799;Combine Edge color with add;1;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;14;-3152.144,530.4159;Float;False;897.6793;426.1704;Lerp the 2 Gradient Bottom Colors according to the above normals y vector;6;28;27;25;22;19;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-596.4163,434.8132;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-2889.452,836.7665;Float;False;-1;;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-3102.526,1285.121;Float;False;Property;_Color5;Color 5;25;0;Create;True;0;0;False;0;0.7259277,0.7647059,0.06185123,0;0.3455882,0.005082184,0.005082184,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;37;-1279.968,269.0193;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;34;-1749.972,-138.7702;Float;False;Property;_Color9;Color 9;21;0;Create;True;0;0;False;0;0.9411765,0.9197947,0.7474049,0;0.9411765,0.9197947,0.7474049,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;25;-2667.547,612.8011;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;24;-2018.037,-473.7972;Float;True;Property;_TextureSample2;Texture Sample 2;24;0;Create;True;0;0;False;0;None;ef0a2cb0ac92c784dbc9a947e8fcb754;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;38;-986.1111,111.0283;Float;True;Property;_TextureSample3;Texture Sample 3;11;0;Create;True;0;0;False;0;None;7ddcba51d9fc0894d98b4ba77fbdfbd7;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;19;-3105.122,747.7228;Float;False;Property;_Color7;Color 7;29;0;Create;True;0;0;False;0;0.3877363,0.5955882,0.188311,0;0.151217,0.3088235,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1484.192,135.1199;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1653.445,-385.5797;Float;False;Property;_Float6;Float 6;23;0;Create;True;0;0;False;0;1;2.34;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-122.4089,-50.98801;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;30;-2130.754,595.7582;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;31;-1831.914,131.5779;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1024.492,-312.7137;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;35;-1327.763,-466.2538;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1770.539,56.47595;Float;False;Property;_Float7;Float 7;22;0;Create;True;0;0;False;0;1;0.03;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-1333.625,-57.81176;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;13;-2882.903,1357.222;Float;False;-1;;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;16;-2662.597,-214.0919;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-3163.49,-129.6523;Float;False;Property;_Float5;Float 5;27;0;Create;True;0;0;False;0;6.4;4.4;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;3;-2849.026,316.222;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;8;-2468.426,320.722;Float;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-734.4042,-67.57904;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-2181.152,324.1914;Float;False;myVarName;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;51;-549.3604,-378.5575;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-2649.623,314.0222;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;2;-3119.968,304.1257;Float;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;27;-2353.221,789.9275;Float;False;-1;;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;22;-3104.822,580.5221;Float;False;Property;_Color8;Color 8;28;0;Create;True;0;0;False;0;0.7058823,0.2024221,0.2024221,0;0.7058823,0.3795011,0.2024219,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;15;-3106.95,1083.013;Float;False;Property;_Color6;Color 6;26;0;Create;True;0;0;False;0;0.2569204,0.5525266,0.7279412,0;0.008620682,0.07352942,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;28;-2421.459,797.3677;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;21;-2714.248,1104.499;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;9;-2845.554,-218.6437;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;50;-384.4053,432.0444;Float;False;Property;_Dither;Dither;9;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;20;-2438.732,-221.3093;Float;False;myVarName;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;7;-3101.689,-296.9541;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;70.2,-117;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;ASE/MapHologram;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;49;0;46;0
WireConnection;49;1;45;0
WireConnection;49;2;44;0
WireConnection;48;0;40;0
WireConnection;48;1;43;0
WireConnection;37;0;30;0
WireConnection;25;0;22;0
WireConnection;25;1;19;0
WireConnection;25;2;18;0
WireConnection;36;0;32;0
WireConnection;36;1;31;0
WireConnection;53;0;52;0
WireConnection;53;1;49;0
WireConnection;30;0;25;0
WireConnection;30;1;28;0
WireConnection;30;2;27;0
WireConnection;31;0;24;2
WireConnection;41;0;35;0
WireConnection;41;1;37;0
WireConnection;35;0;24;1
WireConnection;35;1;29;0
WireConnection;39;0;34;0
WireConnection;39;1;36;0
WireConnection;16;0;9;0
WireConnection;3;0;2;0
WireConnection;8;0;5;0
WireConnection;47;0;41;0
WireConnection;47;1;39;0
WireConnection;11;0;8;0
WireConnection;51;0;47;0
WireConnection;5;0;3;0
WireConnection;5;1;3;0
WireConnection;28;0;21;0
WireConnection;21;0;15;0
WireConnection;21;1;12;0
WireConnection;21;2;13;0
WireConnection;9;0;7;2
WireConnection;9;1;6;0
WireConnection;50;0;43;0
WireConnection;50;1;48;0
WireConnection;20;0;16;0
WireConnection;0;2;53;0
WireConnection;0;9;50;0
ASEEND*/
//CHKSM=606582B81277B5A4E042EFFFFC62B1C7A0308B78