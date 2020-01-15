// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/A_Noise/Voronoi"
{
	Properties
	{
		_AngleOffset("AngleOffset", Float) = 0
		_Density("Density", Float) = 0
		[Toggle]_NoCells("NoCells", Float) = 0
		_Tint("Tint", Color) = (0,0,0,0)
		[Toggle]_VertexOffset("VertexOffset", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _VertexOffset;
		uniform float _NoCells;
		uniform float _AngleOffset;
		uniform float _Density;
		uniform float4 _Tint;


		float2 unity_voronoi_noise_randomVector( float2 UV , float offset )
		{
			    float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
			    UV = frac(sin(mul(UV, m)) * 46839.32);
			    return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
		}


		void Unity_Voronoi_float( float2 UV , float AngleOffset , float CellDensity , out float Out , out float Cells )
		{
			{
			    float2 g = floor(UV * CellDensity);
			    float2 f = frac(UV * CellDensity);
			    float t = 8.0;
			    float3 res = float3(8.0, 0.0, 0.0);
			    for(int y=-1; y<=1; y++)
			    {
			        for(int x=-1; x<=1; x++)
			        {
			            float2 lattice = float2(x,y);
			            float2 offset = unity_voronoi_noise_randomVector(lattice + g, AngleOffset);
			            float d = distance(lattice + offset, f);
			            if(d < res.x)
			            {
			                res = float3(d, offset.x, offset.y);
			                Out = res.x;
			                Cells = res.y;
			            }
			        }
			    }
			}
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float localUnity_Voronoi_float2_g1 = ( 0.0 );
			float2 UV2_g1 = v.texcoord.xy;
			float AngleOffset2_g1 = _AngleOffset;
			float CellDensity2_g1 = _Density;
			float Out2_g1 = 0;
			float Cells2_g1 = 0;
			{
			    float2 g = floor(UV2_g1 * CellDensity2_g1);
			    float2 f = frac(UV2_g1 * CellDensity2_g1);
			    float t = 8.0;
			    float3 res = float3(8.0, 0.0, 0.0);
			    for(int y=-1; y<=1; y++)
			    {
			        for(int x=-1; x<=1; x++)
			        {
			            float2 lattice = float2(x,y);
			            float2 offset = unity_voronoi_noise_randomVector(lattice + g, AngleOffset2_g1);
			            float d = distance(lattice + offset, f);
			            if(d < res.x)
			            {
			                res = float3(d, offset.x, offset.y);
			                Out2_g1 = res.x;
			                Cells2_g1 = res.y;
			            }
			        }
			    }
			}
			float4 temp_output_7_0 = ( lerp(Out2_g1,Cells2_g1,_NoCells) * _Tint );
			float4 Cells8 = temp_output_7_0;
			float3 ase_vertex3Pos = v.vertex.xyz;
			v.vertex.xyz += lerp(float4( 0,0,0,0 ),( ( 1.0 - Cells8 ) * float4( ase_vertex3Pos , 0.0 ) ),_VertexOffset).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float localUnity_Voronoi_float2_g1 = ( 0.0 );
			float2 UV2_g1 = i.uv_texcoord;
			float AngleOffset2_g1 = _AngleOffset;
			float CellDensity2_g1 = _Density;
			float Out2_g1 = 0;
			float Cells2_g1 = 0;
			{
			    float2 g = floor(UV2_g1 * CellDensity2_g1);
			    float2 f = frac(UV2_g1 * CellDensity2_g1);
			    float t = 8.0;
			    float3 res = float3(8.0, 0.0, 0.0);
			    for(int y=-1; y<=1; y++)
			    {
			        for(int x=-1; x<=1; x++)
			        {
			            float2 lattice = float2(x,y);
			            float2 offset = unity_voronoi_noise_randomVector(lattice + g, AngleOffset2_g1);
			            float d = distance(lattice + offset, f);
			            if(d < res.x)
			            {
			                res = float3(d, offset.x, offset.y);
			                Out2_g1 = res.x;
			                Cells2_g1 = res.y;
			            }
			        }
			    }
			}
			float4 temp_output_7_0 = ( lerp(Out2_g1,Cells2_g1,_NoCells) * _Tint );
			o.Emission = temp_output_7_0.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16800
1440;94;1133;1084;991.6774;312.7683;1.288545;True;False
Node;AmplifyShaderEditor.RangedFloatNode;4;-660.4426,150.9673;Float;False;Property;_Density;Density;1;0;Create;True;0;0;False;0;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-666.9427,69.06743;Float;False;Property;_AngleOffset;AngleOffset;0;0;Create;True;0;0;False;0;0;38.68;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-705.943,-115.5326;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;1;-437.8125,-20.00942;Float;False;VoronoiNoise;-1;;1;76ba381fd73950a43850d13494c34c0e;0;3;3;FLOAT2;0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;2;FLOAT;0;FLOAT;6
Node;AmplifyShaderEditor.ColorNode;6;-145.6377,226.3673;Float;False;Property;_Tint;Tint;3;0;Create;True;0;0;False;0;0,0,0,0;0.4411765,0.8150101,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;5;-80.63902,23.56796;Float;False;Property;_NoCells;NoCells;2;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;158.5622,128.8672;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;317.4895,22.2536;Float;False;Cells;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;9;-621.8632,389.4883;Float;False;8;Cells;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;12;-361.5802,461.6472;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;11;-397.6541,626.5806;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-165.716,531.228;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;13;99.72028,430.7227;Float;False;Property;_VertexOffset;VertexOffset;4;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;397.479,156.9504;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;ASE/A_Noise/Voronoi;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1;3;2;0
WireConnection;1;4;3;0
WireConnection;1;5;4;0
WireConnection;5;0;1;0
WireConnection;5;1;1;6
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;8;0;7;0
WireConnection;12;0;9;0
WireConnection;10;0;12;0
WireConnection;10;1;11;0
WireConnection;13;1;10;0
WireConnection;0;2;7;0
WireConnection;0;11;13;0
ASEEND*/
//CHKSM=758B7AB27DA86BB298CC6CD31C91AB083E6671E9