@tool
extends Brush
class_name TerrainHeight
# Brush that creates mountains or valleys when you paint over the terrain
# Paints shades of gray colors over the "texture" depending on the height

const STRENGTH_TO_ALPHA:float = 0.1

@onready var strength:CustomSliderUI = $Strenght
@onready var max_height:CustomNumberInput = $MaxHeight

func _ready():
	max_height.on_change.connect( rebuild_terrain.unbind(1) )

func save_ui():
	_raw.th_texture = _texture
	_raw.th_resolution = _resolution
	_raw.th_strength = strength.value
	_raw.th_max_height = max_height.value

func load_ui(ui:UILandscaper, scene:SceneLandscaper, raw:RawLandscaper):
	super(ui, scene, raw)
	_texture = _raw.th_texture
	_resolution = _raw.th_resolution
	strength.value = _raw.th_strength
	max_height.value = _raw.th_max_height
	_preview_texture()


func paint(pos:Vector3, primary_action:bool):
	var alpha:float = strength.value * STRENGTH_TO_ALPHA
	out_color = Color(1,1,1,alpha) if primary_action else Color(0,0,0,alpha)
	_bake_out_color_into_texture( pos )
	rebuild_terrain()

func rebuild_terrain():
	_ui.terrain_builder.rebuild_terrain()
	update_collider()
	_update_grass()

func update_collider():
	# Caches
	var height_image:Image = _texture.get_image()
	var height_collider:CollisionShape3D = _scene.terrain_collider
	var height_shape:HeightMapShape3D = height_collider.shape
	var bounds_size:Vector2 = _ui.terrain_builder.bounds_size
	
	height_shape.map_width = bounds_size.x + 1
	height_shape.map_depth = bounds_size.y + 1
	height_collider.global_position.x = bounds_size.x * 0.5 + _raw.world_offset.x
	height_collider.global_position.z = bounds_size.y * 0.5 + _raw.world_offset.y
	
	
	# Update _terrain collider
	for x in height_shape.map_width:
		for z in height_shape.map_depth:
			
			# Update height with that pixel's value
			var y:float = height_image.get_pixel(x, z).r * max_height.value
			var coordinate:int = z * (height_shape.map_width) + x
			height_shape.map_data[coordinate] = y
	

func _update_grass():
	# Caches
	var space := _scene.terrain.get_world_3d().direct_space_state
	var ray := PhysicsRayQueryParameters3D.new()
	ray.collision_mask = 1<<(PluginLandscaper.COLLISION_LAYER_TERRAIN-1)
	
	# Raycast collider for the exact ground level position
	for multimesh_inst in _scene.grass_holder.get_children():
		var multimesh:MultiMesh = multimesh_inst.multimesh
		for instance_index in multimesh.instance_count:
			var transform:Transform3D = multimesh.get_instance_transform(instance_index)
			
			ray.from = transform.origin + Vector3.UP * max_height.value
			ray.to = transform.origin + Vector3.DOWN * max_height.value
			var result = space.intersect_ray(ray)
			
			# Update the new height with that collision point
			transform.origin.y = result.position.y
			multimesh.set_instance_transform(instance_index , transform)
	

# Has to have one pixel more for the extra vertex
func extend_texture(min:Vector2i, max:Vector2i, fill_color:Color):
	super(min, max + Vector2i.ONE, fill_color)
