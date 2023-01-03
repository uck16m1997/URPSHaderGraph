# Computer Graphics Concepts
## Resources
- https://learnopengl.com/Introduction

## Color
- RGB with additive color model https://en.wikipedia.org/wiki/Additive_color.
- If transparency is required 4th alpha channel is also included
- Values are stored as normalized values between 0 and 1 or 0 and 255.

## UV
- UV values for texture always range between 0 and 1
- u is used to measure horizontal distance and v is used for measuring vertical distance
- Top right corner is 1,1, bottom left corner is 0,0, Bottom right corner is 1,0 and Top left corner is 0,1
- uv's are mapped in an anti clockwise order (right hand rule)
- Similar shaped meshes can be processed together but if meshes have different textures they will be in different batches. To get meshes to look different but use same texture we can use a texture atlas.

## Lighting 
- Light sources consist of 3 primary lighting interactions
  - Ambient lighting which represents the background light of the environment
  - Diffuse light which comes from a light source and illuminates the geography of an object
  - Specular light which bounces of the surfaces and can be used to create shiny patches
- Lighting model needs usually three things 
  - The normal vector of the surface
  - Vector to the viewer of the surface
  - Vector to the light source
  - Sometimes the exact point on the surface is included 
- Lighting in computer graphic is all about calculating the intensity and color of the light reaching the viewer by computing the angles between above mentioned vectors.

- <b>Lambert lighting: </b> model defines the relationship between the brightness of a surface and its orientation to the light source. 
  - Smaller the angle between lightsource and normal are brighter the lighting will be by using cos function. 
  - If the angle is more than 90 than light is coming from behing the surface so no lighting will be rendered. 
  - N . L (Dot Prodcut)= | N (Normal Vector) | * |L (Light Vector) | * cos(a)
  - I (Intensity) = N . L * Color * Atennuation

- <b>Phong lighting (Specular Reflection): </b> model includes the calculation of specular reflection or how light bounces of the surface.

  - Reflection will be at its strongest when the angle between lightsource and normal is equal to the angle between normal and reflection vector. 
  - Further away from the outgoing angle the reflection falloff will depend on the quality of surface shiny objects have quicker fallofs.
  - The amount of reflection the viewer sees will depend on the angle between the reflection vector and the vector to the viewer.
  - Blinn-Phong lighting model simplifies the calculations by adding in a halfway vector between the light source and the viewer and reduces the need to calculate the reflection vector which requires a cosine operation.
  - h (halfway vector) = s (vector to the lightsource) + v (vector to the viewer)
  - N . h * color * Attenuation

- <b>Physical-Based Rendering</b> (PBR) Lighting Model has a goal of photo realism.

  - <b>Reflection</b> is accomplished by drawing rays from the viewer to the reflective surface and calculat,ng where it bounces off. (Reverse calculation of lighting)
  - <b>Diffusion</b> is how color and light are distributed across the surface by considering what light is absorbed and what light is reflected.
  - <b>Translucency and Transparency</b> is how light can move through objects and render them fully or partly see through.
  - <b> Conservation of Energy </b> is a concept that ensures objects never reflect more light than they receive.
  - <b> Metallicity </b> considers the interaction of light on shiny surfaces and highlights and colors that are reflected.
  - <b> Fresnel Reflectivity </b> examines how reflections on curved surface become stronger towards the edges.
  - <b> Microsurface Scattering </b> like bump mapping suggests that most surfaces contains grooves and cracks that will reflect the light at different angles other than dictated by the original surface.


- <b> Vertex Lit </b> is where the incoming light is calculated at each vertex and then averaged across the surface.
- <b>Pixel Lit </b> is phong like where light for each pixel is calculated but requires more processing.

## Coordinate Spaces
- Worldspace is the axis of x,y,z that is used to describe the world and is independent to anything.
- Objectspace have its own front,left and up which will change with object rotates.
- Viewspace is the front/depth(z),left(x) and up(y) if the camera rotates it will change the viewspace locations.
- Tangentspace has vertex becoming the center of the space and vertices have normal(perpendicular,z,n) and tangent(side,x,u), binormal(up,y,v) which will change with the rotation of the object it belongs to.


## Render Pipelines
- HDRP targets high end hardware with the purpose of produce the highest quality video on the screen with Ray Tracing lighting functionalities. HDRP rendering pipeline might lock more CPU and GPU and not leave enough for scripting intensive games.
- URP targets broader end devices https://docs.unity3d.com/Packages/com.unity.render-pipelines.universal@14.0/manual/index.html.
- Bent Normals (included in HDRP) are special version of Normal Map with Ambient Occlusion built in.
- https://portal.productboard.com/unity/1-unity-platform-rendering-visual-effects/tabs/3-universal-render-pipeline
## Rasterization Pipeline

1. 3D Model: Contains vertices, normals, uvs, tangents.
2. Vertex Processing: Computes normalised coordinate space of the vertices
3. Primitive Processing: Vertices are grouped in primitives like triangles and triangles are clipped and culled
4. Rasterization: Triangles are filled in to produce fragments
5. Fragment Processing: Fragments are coloured
6. Depth & Colour Buffer Processsing: Reads from buffer and outputs image in pixels

- In Forward Rendering each models mesh gets passed to Depth & Colour buffers and get compared before pixels get rendered to screen.
- In Deferred Rendering Fragment Processing won't apply lighting when colouring each fragment will go to G-Buffer.
- G-Buffer contains Depth,Normal and Color Maps and final Fragment Pass happens to colour lighting on only visible pixels by comparing their depth.
- Older video cards and semi-transparent objects don't support Deffered Rendering.
- Anti aliasing isn't naturally supported in Deffered Rendering and used as FXAA.
- Any object that isn't supported by Deffered can be drawn afterwards with Forward.
- <b>Forward Renderer Draw Call count:</b>  number_of_meshes * number_of_lights* number_of_views.
- <b>Deffererd Renderer Draw Call count:</b> number_of_meshes + number_of_lights* number_of_views.
- https://docs.unity3d.com/Manual/RenderTech-ForwardRendering.html
- https://docs.unity3d.com/Manual/RenderTech-DeferredShading.html