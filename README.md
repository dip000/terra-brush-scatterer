# Godot Landscaper
Terrain builder, terrain texturizer, instance scatterer, grass scatterer, grass colorer. Based on textures and paintbrushes

<p align="center">
<img src="https://github.com/user-attachments/assets/bfd10141-fedc-4150-957d-71ee44a58d63">
<p/>


**🌟 Update**: Added scene instancer brush. Paint-spawn rocks, trees, particles, people, and anything you want! <br/>
**🌟 Update**: You can move your terrain wherever you please and the canvas will follow it (finally yay!) <br/>
**🌟 Update**: Critical fixes are open before launch. Please propose them by joining the conversation in [THIS THREAD](https://github.com/dip000/godot-landscaper/discussions/4). Thanks!
<br/>
<br/>

## Content
1. [Features And How To Use Them](#features-and-how-to-use-them):
	- [Terrain Builder](#terrain-builder)
	- [Terrain Color](#terrain-color)
	- [Terrain Height](#terrain-height)
	- [Grass Color](#grass-color)
	- [Grass Spawn](#grass-spawn)
	- [Instancer](#instancer)

2. [Performance Concerns](#performance-concerns)
3. [Addressing Current Caveats](#addressing-current-caveats)
4. [Roadmap To Beta And Asset Library](#roadmap-to-beta-and-asset-library)
5. [Author Notes](#author-notes)



# Features And How To Use Them
Follow the next steps:
1. Download and install this Plugin. See [installing_plugins](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html)
2. Open a scene, and instantiate a 'SceneLandscaper' node in the scene tree. It will create a new terrain template
3. Select the 'SceneLandscaper' node and go to the "Landscaper" tab over the right dock.
4. Select your brush and click and drag over your terrain to start landscaping!

## Terrain Builder
Brush that generates new mesh when you paint over the terrain.<br />
Paint with left-click to build a new mesh, and paint with right-click to erase.<br />
![TerrainBuilder](https://github.com/dip000/godot-landscaper/assets/58742147/63591979-0ab5-4e3e-a08b-ecf8109fa383)

Brush Properties:
* **Canvas Size:** Size of the effective building area in meters squared, centered in your terrain<br />
>Note that the canvas will always follow your terrain wherever you move it<br />


## Terrain Color
Brush that color-paints your created terrain.<br />
Paint with the selected color using left-click, use right-click to smooth the selected color.<br />
![TerrainColor](https://github.com/dip000/godot-landscaper/assets/58742147/50506297-cd5a-45b5-9ae0-726c645af90c)


Brush Properties:
* **Color:** Color of the terrain paint<br />
* **Resolution:** Size of the texture in pixels per meter<br />
> This texture is saved in the file system with size = resolution*terrain_size


## Terrain Height
Brush that changes the height of your created terrain.<br />
Create mounds with left-click, and create ditches with right-click.<br />
![TerrainHeight](https://github.com/dip000/godot-landscaper/assets/58742147/536f8b03-8d91-45b8-b485-50eedb89bbb9)


Brush Properties:
* **Strenght:** How quickly you want to raise or lower the ground when you paint over the terrain
* **Max Height:** How the grayscale of this texture is interpreted in the real world. This property is *not* destructive<br />
* **Apply To All:** Applies a soft black/white mask over the whole texture. This property *is* destructive<br />


## Grass Color
Brush that color-paints your spawned grass.<br />
Paint with the selected color using left-click, use right-click to smooth the selected color.<br />
![GrassColor](https://github.com/dip000/godot-landscaper/assets/58742147/c922ce65-ff0d-4db3-92f7-d1177b16bb60)

Brush Properties:
* **Color:** Color of the terrain paint<br />

>Note that only the top of the grass is being colored. That's because the bottom half is taking the color of the terrain!<br />


## Grass Spawn
Brush that spawns new grass over your created terrain.<br />
Spawn grass with left-click to spawn your selected grass variant or right-click to clear any grass<br />
![GrassSpawn](https://github.com/dip000/godot-landscaper/assets/58742147/61b742fe-cd7c-4051-b897-49aee6160d1f)

Brush Properties:
* **Density:** How many grass instances are inside the area you have painted with this brush
* **Quality:** Subdivisions for each blade of grass. This affects its sway animation and gradient color smoothness (because is vertex colored)
* **Gradient Value:** The color mix from the grass roots to the top as seen from the front. BLACK=terrain_color and WHITE=grass_color
* **Enable Details:** Renders the details of your grass variant texture. These are the sharp margin edges in the preview grass shown here
* **Detail Color:** Recolor of the black tint of your grass texture. Has no effect if your grass doesn't have details to begin with
* **Size:** Size of the average blade of grass in meters
* **Variants:** A list of grass textures to use. Does not create extra materials but more than one requires a Forward+ renderer.
* **Billboard:** Types of billboarding. BillboardY (grass always looks at the camera), CrossBillboard (for each grass, spawns another 90 degrees in the same position), and Scatter (Scatters the grass with random rotations)

## Instancer
Brush that spawns your custom scenes<br />
Spawn with the selected scene using left-click, use right-click to erase.<br />
![Instancer](https://github.com/dip000/godot-landscaper/assets/58742147/06fe973b-a687-4126-8bc5-bf75a0045844)


Brush Properties:
* **Scene:** Open or drag-and-drop your scene with the extension ".tscn" or ".scn". Instancer will load it and instance it from here. Clear it by erasing the path<br />
* **Randomness:** Random range between 0(0%) and 360(100%) degrees that the instance will be spawned with.<br />


# Performance concerns
About Textures:
* Terrain and Grass color textures are stored in separate files as PNG and their size in pixels is calculated as "resolution*world_size". This means that the file is as big as the terrain's bounding box.
* Terrain and Grass color textures are not mipmapped (LOD) internally, but after saving the project they can be mipmapped by the user on import settings.
* Every texture except Terrain and Grass color, is stored in a "project.res" file. They are not relevant for end-products and the project file itself can be deleted if the user doesn't want to edit the landscape anymore.

About Grass:
* This version now supports GL Compatibility rendering! But it is limited to one grass variant due to the lack of shader instance variables in Compatibility
* Coloring the grass is optimized by using vertex colors. This means that the shader is only coloring as few as 4 vertex per instance (The vertices of a square)
* You can set how many vertex to use per grass in "GrassSpawn Brush > Quality"
* Grass chunking has not been implemented yet.


# Addressing Current Caveats
About Spaghetti Code:
* It's not a secret that some things are just poorly patched, this is mostly due to this plugin being "designed to be a dog house but ending up as mansion". The very first iteration was just a tool script to scatter grass... Needless to say, the dog house builder (a.k.a DIP) had to learn how to build a mansion and things ended up barely holding together. This may or may not be fixed in the future, depending on if it catches up in the community and if it is worth the struggle, after all, Godot has no real market to make a profit out of this.

About Bugs That I Couldn't Fix:
* **Click-trough:** When you click over any UI window in front of the 3D scene, the scene will also receive the click and you might end up painting a big ugly spot on your terrain. Same as before, I lack the information to know how to fix this
* **Imperfect RNG:** To spawn random things like grass and instances, the current random number generators make the spawning consistent, but you might quickly notice that it suddenly changes and your tree is now looking west instead of north. That's because the RNGs are based on the size of the terrain, so when the terrain bounding box changes, the RNG pattern changes. I haven't found a good approach to solve this issue since we have to raycast a LOT of random spawn points, and basing the RNGs in something more consistent like a 100x100 meters area will be a lot more costly 
* **Expanding Textures:** When you press [Save Project], extend the terrain, then press [Load Project]. It will try to extend the previous image, looks awful, and creates errors down the line. Right now I don't have a proper way to handle this issue
* **Random Errors:** Sometimes, GodotLandscaper just doesn't want to work. In that case, try disabling-enabling the plugin, then selecting-deselecting the SceneLandscaper a few times *shrugs*

About Backward Compatibility:
* Version control was not even planned and loading previous versions might not work right off the bat. However, you can always load the previous version resources manually and go about fixing the details. After all, this plugin is purely based on textures, so in the textures is all the information to rebuild your terrain

About Using External Tools For Fine-texturing:
* This is possible by saving your project, opening the outputted textures with your preferred tool like Photoshop, and then saving them back as png with the same size. GodotLandscaper will always run an input format to decompress, de-mipmap, and convert to RGBA every time you press "Load Project" from the Landscaper tab. However, I cannot say for certain that this will work for every case

About Shading or Un-cartooning The Meshes:
* By default, the landscaper will set the terrain material as StandardMaterial3D with shading as SHADING_MODE_UNSHADED, and the ShaderMaterial of the grass is set as unshaded (from code).
* This makes the colors of both - the terrain and grass - match perfectly regardless of the lighting. This is great for cartoonish styles but far from a PBR landscape. Now, you can enable shading to both of them by accessing the mentioned properties but now you'll have to fix the colors with either lights, emissions, or postprocessing because that's not something that the landscaper can do on its own. Also, for performance (and definitely not because I don't know how) you'd need to set the normals of every blade of grass from the shader so the lighting is received correctly.

# Roadmap to Beta and Asset Library
1. [X] Save And Bake Everything In A External Folder
	- [X] Keep TerraBrush open for modifications
	- [X] Clear all plugin dependencies. Like in [this repository for shaders](https://github.com/dip000/my-godotshaders/tree/main/StylizedCartoonGrass)

2. [X] Add Support For Multiple Grass Billboarding Options
	- [X] Cross billboard
	- [X] Billboard Y
 	- [X] Scatter

3. [X] Add Terrain Generator Brush
	- [X] Click over the terrain and create a mesh surface
	- [X] Meshes are ImmediateMesh that are generated dynamically instead of using a shader

4. [X] Dedicated UI For Paintbrushes
	- [X] Custom control in rightmost Dock
	- [X] Recouple brushes for this new system

5. [X] Add Instancer Brush
	- [X] Use the same logic as the grass spawner but with custom scenes instead of grass

6. [ ] Critical Bug Fixes
	- [ ] A small period when the most game-breaker bugs will get fixed. No major updates will be coming up

7. [ ] To The Asset Library
   - [ ] [asset library requirements](https://docs.godotengine.org/en/stable/community/asset_library/submitting_to_assetlib.html)
   - [ ] In-code Documentation following [style guides](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#doc-gdscript-styleguide)


# Author notes
Hi, nickname's DIP. Thanks for passing by!<br />

I'd be glad to hear what you have to say about the grass shader [HERE](https://godotshaders.com/shader/stylized-cartoon-grass/). Or contact me about this plugin at [ab-cb@hotmail.com](mailto:ab-cb@hotmail.com?subject=[GitHub]%20Godot%20Landscaper%20Plugin)<br />
See ya!<br />

*And for those who sent their feedback, thank you very much!*
