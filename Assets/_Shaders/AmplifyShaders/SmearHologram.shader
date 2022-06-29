// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/A_Hologram/SmearHologram"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.67
		_NoiseInfluence("Noise Influence", Range( 0 , 1)) = 0.5
		_NoiseHeightScale("Noise Height Scale", Range( 0 , 1)) = 0
		_NoiseTilling("Noise Tilling", Float) = 5
		_SmearIntensity("Smear Intensity", Range( 0 , 1000)) = 1
		_Pattern("Pattern", 2D) = "white" {}
		_ShieldColor("Shield Color", Color) = (0.1693339,0.7941176,0.4580271,1)
		_ShieldBrightness("Shield Brightness", Range( 0 , 10)) = 0
		_RimPower("Rim Power", Range( 0 , 5)) = 0
		_WaveEffect("Wave Effect", 2D) = "white" {}
		_WaveSpeed("Wave Speed", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			half2 uv_texcoord;
			float3 worldNormal;
			half4 screenPosition;
		};

		uniform half _NoiseTilling;
		uniform half _NoiseHeightScale;
		uniform half _NoiseInfluence;
		uniform half3 _Position;
		uniform half3 _PrevPosition;
		uniform half _SmearIntensity;
		uniform sampler2D _Pattern;
		uniform half4 _Pattern_ST;
		uniform half _RimPower;
		uniform half4 _ShieldColor;
		uniform half _ShieldBrightness;
		uniform sampler2D _WaveEffect;
		uniform half _WaveSpeed;
		uniform float _Cutoff = 0.67;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


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
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float simplePerlin3D5_g3 = snoise( ( ase_worldPos * _NoiseTilling ) );
			float lerpResult10_g3 = lerp( 1.0 , ( 1.0 - ( simplePerlin3D5_g3 * _NoiseHeightScale ) ) , _NoiseInfluence);
			float Noise11_g3 = lerpResult10_g3;
			float3 worldOffset20_g3 = ( _Position - _PrevPosition );
			float3 normalizeResult21_g3 = normalize( worldOffset20_g3 );
			float3 localOffset19_g3 = ( ase_worldPos - _Position );
			float3 normalizeResult22_g3 = normalize( localOffset19_g3 );
			float dotResult23_g3 = dot( normalizeResult21_g3 , normalizeResult22_g3 );
			float smearDirection24_g3 = dotResult23_g3;
			float clampResult26_g3 = clamp( smearDirection24_g3 , -1.0 , 0.0 );
			float lerpResult30_g3 = lerp( 1.0 , 0.0 , step( length( worldOffset20_g3 ) , 0.0 ));
			half3 temp_cast_0 = (-_SmearIntensity).xxx;
			half3 temp_cast_1 = (_SmearIntensity).xxx;
			float3 clampResult34_g3 = clamp( worldOffset20_g3 , temp_cast_0 , temp_cast_1 );
			float3 Bulge38_g3 = -( ( -clampResult26_g3 * lerpResult30_g3 ) * clampResult34_g3 );
			float3 finalVertexWorldPosition45_g3 = ( ( Noise11_g3 * Bulge38_g3 ) + ase_worldPos );
			float4 appendResult46_g3 = (half4(finalVertexWorldPosition45_g3 , 1.0));
			v.vertex.xyz += mul( unity_WorldToObject, appendResult46_g3 ).xyz;
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			o.screenPosition = ase_screenPos;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Pattern = i.uv_texcoord * _Pattern_ST.xy + _Pattern_ST.zw;
			float3 ase_worldPos = i.worldPos;
			half3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			half3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV8 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode8 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV8, _RimPower ) );
			float mulTime2 = _Time.y * _WaveSpeed;
			float2 panner3 = ( mulTime2 * float2( 0,-1 ) + float2( 0,0 ));
			float2 uv_TexCoord4 = i.uv_texcoord + panner3;
			float4 WavyEffect9 = tex2D( _WaveEffect, uv_TexCoord4 );
			o.Emission = ( ( tex2D( _Pattern, uv_Pattern ) + fresnelNode8 ) * _ShieldColor * _ShieldBrightness * WavyEffect9 ).rgb;
			o.Alpha = 1;
			float4 ase_screenPos = i.screenPosition;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 clipScreen25 = ase_screenPosNorm.xy * _ScreenParams.xy;
			float dither25 = Dither8x8Bayer( fmod(clipScreen25.x, 8), fmod(clipScreen25.y, 8) );
			clip( dither25 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack2.xyzw = customInputData.screenPosition;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.screenPosition = IN.customPack2.xyzw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16800
0;73;1686;1286;1320.926;796.9268;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;1;-1380.258,197.524;Float;False;Property;_WaveSpeed;Wave Speed;14;0;Create;True;0;0;False;0;0;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;-1177.242,200.1267;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;3;-979.4326,187.1133;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-725.6625,161.086;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-1153.861,-91.48101;Float;False;Property;_RimPower;Rim Power;12;0;Create;True;0;0;False;0;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-422.4408,167.5928;Float;True;Property;_WaveEffect;Wave Effect;13;0;Create;True;0;0;False;0;None;e06510d66e790dc4bb7ed2e7d198ecb1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;8;-881.4556,-280.082;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-898.7604,-505.0226;Float;True;Property;_Pattern;Pattern;6;0;Create;True;0;0;False;0;None;9fbef4b79ca3b784ba023cb1331520d5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-57.59579,227.0166;Float;False;WavyEffect;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-493.175,21.14585;Float;False;9;WavyEffect;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-504.851,-449.7824;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;15;-579.4009,-271.3724;Float;False;Property;_ShieldColor;Shield Color;7;0;Create;True;0;0;False;0;0.1693339,0.7941176,0.4580271,1;0.1693339,0.7941176,0.4580271,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;29;-1182.578,-1358.428;Float;False;1164.151;778.9543;Intersect not really working right now;7;7;21;12;22;16;13;27;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-589.2099,-78.89071;Float;False;Property;_ShieldBrightness;Shield Brightness;8;0;Create;True;0;0;False;0;0;1.1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-142.8993,-430.9641;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;27;-428.6981,-912.4388;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;21;-402.5138,-1211.252;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;12;-562.0939,-1082.983;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-700.2449,-767.1636;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DitheringNode;25;198.4323,-382.5066;Float;False;1;False;3;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-987.0263,-690.2615;Float;False;Property;_IntersectIntensity;Intersect Intensity;11;0;Create;True;0;0;False;0;50;5.24;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-973.572,-921.3192;Float;False;Property;_IntersectColor;Intersect Color;9;0;Create;True;0;0;False;0;1,0,0,1;1,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-674.4241,-915.9208;Float;False;Property;_IntersectDepth;Intersect Depth;10;0;Create;True;0;0;False;0;0;0.135;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;20;66.7737,-259.8156;Float;True;SmearDY;1;;3;1710975ae39d34d4982db9132aa7b859;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;441.6322,-564.5964;Half;False;True;2;Half;ASEMaterialInspector;0;0;Standard;ASE/A_Hologram/SmearHologram;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.67;True;True;0;False;TransparentCutout;;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;3;1;2;0
WireConnection;4;1;3;0
WireConnection;5;1;4;0
WireConnection;8;3;6;0
WireConnection;9;0;5;0
WireConnection;11;0;10;0
WireConnection;11;1;8;0
WireConnection;18;0;11;0
WireConnection;18;1;15;0
WireConnection;18;2;17;0
WireConnection;18;3;14;0
WireConnection;27;0;22;0
WireConnection;27;2;21;0
WireConnection;21;0;12;0
WireConnection;12;0;7;0
WireConnection;22;0;16;0
WireConnection;22;1;13;0
WireConnection;0;2;18;0
WireConnection;0;10;25;0
WireConnection;0;11;20;0
ASEEND*/
//CHKSM=3414B4D2A33A4D80D0276E0B382A4672F909C939