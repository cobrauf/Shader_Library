// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/TwoSided"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.24
		_Mask("Mask", 2D) = "white" {}
		_FrontTint("FrontTint", Color) = (1,0.375,0.375,0)
		_FrontAlbedo("FrontAlbedo", 2D) = "white" {}
		_BackTint("BackTint", Color) = (0.3965517,1,0.375,0)
		_BackAlbedo("BackAlbedo", 2D) = "white" {}
		_FrontNormal("FrontNormal", 2D) = "white" {}
		_BackNormal("BackNormal", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			half ASEVFace : VFACE;
		};

		uniform sampler2D _FrontNormal;
		uniform float4 _FrontNormal_ST;
		uniform sampler2D _BackNormal;
		uniform float4 _BackNormal_ST;
		uniform float4 _FrontTint;
		uniform sampler2D _FrontAlbedo;
		uniform float4 _FrontAlbedo_ST;
		uniform float4 _BackTint;
		uniform sampler2D _BackAlbedo;
		uniform float4 _BackAlbedo_ST;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform float _Cutoff = 0.24;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_FrontNormal = i.uv_texcoord * _FrontNormal_ST.xy + _FrontNormal_ST.zw;
			float2 uv_BackNormal = i.uv_texcoord * _BackNormal_ST.xy + _BackNormal_ST.zw;
			float3 switchResult6 = (((i.ASEVFace>0)?(UnpackNormal( tex2D( _FrontNormal, uv_FrontNormal ) )):(UnpackNormal( tex2D( _BackNormal, uv_BackNormal ) ))));
			o.Normal = switchResult6;
			float2 uv_FrontAlbedo = i.uv_texcoord * _FrontAlbedo_ST.xy + _FrontAlbedo_ST.zw;
			float2 uv_BackAlbedo = i.uv_texcoord * _BackAlbedo_ST.xy + _BackAlbedo_ST.zw;
			float4 switchResult3 = (((i.ASEVFace>0)?(( _FrontTint * tex2D( _FrontAlbedo, uv_FrontAlbedo ) )):(( _BackTint * tex2D( _BackAlbedo, uv_BackAlbedo ) ))));
			o.Albedo = switchResult3.rgb;
			o.Alpha = 1;
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			clip( tex2D( _Mask, uv_Mask ).r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16800
1753;94;1279;1084;1196.916;421.7819;1.072896;True;False
Node;AmplifyShaderEditor.ColorNode;2;-1003.795,-850.9401;Float;False;Property;_FrontTint;FrontTint;2;0;Create;True;0;0;False;0;1,0.375,0.375,0;1,0.375,0.375,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-1018.813,-649.2339;Float;True;Property;_FrontAlbedo;FrontAlbedo;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;10;-1030.615,-251.1902;Float;True;Property;_BackAlbedo;BackAlbedo;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-983.411,-437.875;Float;False;Property;_BackTint;BackTint;4;0;Create;True;0;0;False;0;0.3965517,1,0.375,0;0.3965517,1,0.375,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-616.4773,-392.8136;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-545.6679,-584.8599;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;5;-740.936,80.33389;Float;True;Property;_FrontNormal;FrontNormal;6;0;Create;True;0;0;False;0;None;9a4a55d8d2e54394d97426434477cdcf;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;-737.7174,282.0381;Float;True;Property;_BackNormal;BackNormal;7;0;Create;True;0;0;False;0;None;77fdad851e93f394c9f8a1b1a63b56f3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwitchByFaceNode;6;-360.0582,96.42746;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1;-480.2212,445.1188;Float;True;Property;_Mask;Mask;1;0;Create;True;0;0;False;0;61c0b9c0523734e0e91bc6043c72a490;61c0b9c0523734e0e91bc6043c72a490;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwitchByFaceNode;3;-357.9119,-299.4714;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-68.66532,50.42609;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;ASE/A_Custom/TwoSided;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.24;True;True;0;True;Opaque;;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;4;0
WireConnection;12;1;10;0
WireConnection;11;0;2;0
WireConnection;11;1;9;0
WireConnection;6;0;5;0
WireConnection;6;1;8;0
WireConnection;3;0;11;0
WireConnection;3;1;12;0
WireConnection;0;0;3;0
WireConnection;0;1;6;0
WireConnection;0;10;1;0
ASEEND*/
//CHKSM=F1425A4FAB3A4C05090AD47A38F255C20065DC39