Shader "Lightmapped/VertexLit ColorMask" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Spec Color", Color) = (1,1,1,1)
	_Shininess ("Shininess", Range (0.01, 1)) = 0.7
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_LightMap ("Lightmap (RGB)", 2D) = "black" {}
}

// ------------------------------------------------------------------
// Three texture cards (Radeons, GeForce3/4Ti and up)

SubShader {
	/* Upgrade NOTE: commented out, possibly part of old style per-pixel lighting: Blend AppSrcAdd AppDstAdd */
	Fog { Color [_AddFog] }
	ColorMask RGB

	// Ambient pass
	Pass {
		Name "BASE"
		Tags {"LightMode" = "Always" /* Upgrade NOTE: changed from PixelOrNone to Always */}
		Color [_PPLAmbient]
		BindChannels {
			Bind "Vertex", vertex
			Bind "normal", normal
			Bind "texcoord1", texcoord0 // lightmap uses 2nd uv
			Bind "texcoord", texcoord1 // main uses 1st uv
		}
		SetTexture [_LightMap] {
			constantColor [_Color]
			combine texture * constant
		}
		SetTexture [_MainTex] {
			constantColor [_Color]
			combine texture * previous, texture * constant
		}
	}
	
	// Vertex lights
	Pass {
		Name "BASE"
		Tags {"LightMode" = "Vertex"}
		Material {
			Diffuse [_Color]
			Shininess [_Shininess]
			Specular [_SpecColor]
		}

		Lighting On
		SeparateSpecular On

		BindChannels {
			Bind "Vertex", vertex
			Bind "normal", normal
			Bind "texcoord1", texcoord0 // lightmap uses 2nd uv
			Bind "texcoord1", texcoord1 // lightmap uses 2nd uv
			Bind "texcoord", texcoord2 // main uses 1st uv
		}
		
		SetTexture [_LightMap] {
			constantColor [_Color]
			combine texture * constant
		}
		SetTexture [_LightMap] {
			constantColor (0.5,0.5,0.5,0.5)
			combine previous * constant + primary
		}
		SetTexture [_MainTex] {
			combine texture * previous DOUBLE, texture * primary
		}
	}
}

// ------------------------------------------------------------------
// Dual texture cards - draw in two passes

SubShader {
	/* Upgrade NOTE: commented out, possibly part of old style per-pixel lighting: Blend AppSrcAdd AppDstAdd */
	Fog { Color [_AddFog] }

	// Always drawn base pass: texture * lightmap
	Pass {
		Name "BASE"
		Tags {"LightMode" = "Always"}
		Color [_PPLAmbient]
		BindChannels {
			Bind "Vertex", vertex
			Bind "normal", normal
			Bind "texcoord1", texcoord0 // lightmap uses 2nd uv
			Bind "texcoord", texcoord1 // main uses 1st uv
		}
		SetTexture [_LightMap] {
			constantColor [_Color]
			combine texture * constant
		}
		SetTexture [_MainTex] {
			combine texture * previous, texture * primary
		}
	}
	
	// Vertex lights: add lighting on top of base pass
	Pass {
		Name "BASE"
		Tags {"LightMode" = "Vertex"}
		Material {
			Diffuse [_Color]
			Shininess [_Shininess]
			Specular [_SpecColor]
		}

		Lighting On
		SeparateSpecular On
		
		ColorMask RGB

		SetTexture [_MainTex] {
			combine texture * primary DOUBLE, texture
		}
	}
}

// ------------------------------------------------------------------
// Single texture cards - lightmap and texture in two passes; no lighting

SubShader {
	/* Upgrade NOTE: commented out, possibly part of old style per-pixel lighting: Blend AppSrcAdd AppDstAdd */
	Fog { Color [_AddFog] }

	// Base pass: lightmap
	Pass {
		Name "BASE"
		Tags {"LightMode" = "Always"}
		BindChannels {
			Bind "Vertex", vertex
			Bind "texcoord1", texcoord0 // lightmap uses 2nd uv
		}
		SetTexture [_LightMap] { constantColor [_Color] combine texture * constant }
	}
	
	// Second pass: modulate with texture
	Pass {
		Name "BASE"
		Tags {"LightMode" = "Always"}
		BindChannels {
			Bind "Vertex", vertex
			Bind "texcoord", texcoord0 // main uses 1st uv
		}
		Blend Zero SrcColor
		SetTexture [_MainTex] { combine texture }
	}
}

Fallback "VertexLit", 1

}
