# ShaderGraph Doc

## Working Mechanics
- Vertex part runs once for every vertex in your model parallely on the GPU.
- Fragment part operates once for each fragment/triangles.

## ShaderGraph Hotkeys
- Middle mouse button is used for zooming
- Alt Click keys will be used to drag the view
- A key will focus on all the blocks
- F key will focus on selected block
- Square brackets will cycle through the blocks
- We can right click to create sticky notes for comments

## Components
- Properties and Keywords are used similar to variables in C# code.
- Vertex or the Context block is the part which 3D Mesh data(Vertex Positions,Normals,Tangents(used for bump mapping) and optionally UV mappings) is passed in to the shader code to draw objects
- Fragment Block is responsible for coloring in the pixels in the fragments

## Data Types
- <b>float:</b> Highest precision, 32 bits used for world positions, texture coordiantes, etc ...
- <b>half:</b> Half precision, 16 bits used for short vectors, directions and dynamic color ranges
- <b>fixed:</b> Lowest preciision, 11 bits used for regular colors and color operations
- <b>int:</b> used for coutners and array indices
- <b> Texture Data Types</b>
  - <b>sampler2D:</b> optionaly_float/_half for precision used for 2D textures
  - <b>samplerCUBE:</b> optionaly_float/_half for precision used for cube maps
- <b>Packed Arrays</b> are created with variable name and length of the array float3, float4 and array values can be accessed with r,g,b,a or x,y,z,w such as arr.rgb
- <b> Packed Matrices</b> are created as float4x4, float3x3 and values can be access with matrix._m00_m01_m02, matrix[0] can be used to get rows with indexes as well
