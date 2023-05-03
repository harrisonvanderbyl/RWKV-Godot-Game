extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var visi = 255
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_layer_modulate(1,lerp(get_layer_modulate(1),Color8(255,255,255,visi),0.1))


func _on_area_2d_body_entered(body):
	visi=0


func _on_area_2d_body_exited(body):
	visi=255
