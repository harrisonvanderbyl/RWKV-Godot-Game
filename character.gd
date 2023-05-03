extends RigidBody2D
var rwkv = GodotRWKV.new()
var onsomething = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Node2D/AnimatedSprite2D.play("default")
	rwkv.loadModel("/media/harrison/0F8D9B194C1273DC/model.bin")
	rwkv.loadTokenizer("/home/harrison/Desktop/rwkvstic/src/rwkvstic/agnostic/backends/cuda/cudarwkv/rwkv-cpp-cuda/include/rwkv/tokenizer/vocab/")
	
var anitee = 0.0
var tm = 0.0
var timeout = 0
var talking = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	tm += 0.1
	timeout = max(0,timeout-1)
	var talk = Input.is_action_just_pressed("talk")
	var escape = Input.is_action_just_pressed("escape")
	var enter = Input.is_action_just_pressed("enter")
	if(not talking):
		var eventl = Input.is_action_pressed("left")
		var evenlr = Input.is_action_just_released("left")
		var eventr = Input.is_action_pressed("right")
		var evenrr = Input.is_action_just_released("right")
		var evenj = Input.is_action_just_pressed("jump")
		
		if evenlr:
				apply_impulse(Vector2(100,0))
		if evenrr:
				apply_impulse(Vector2(-100,0))
		if !onsomething and timeout == 0:
			
			if eventl:
				apply_impulse(Vector2(-15,0))
				timeout = 2
			if eventr:
				apply_impulse(Vector2(15,0))
				timeout = 2
		
		if onsomething and timeout == 0:
			#var dir = $PinJoint2D/RigidBody2D.get_colliding_bodies()[0]
			
			if eventl:
				apply_impulse(Vector2(-150,-450))
				timeout = 10
			if eventr:
				apply_impulse(Vector2(150,-450))
				timeout = 10
		
		if onsomething:
			if evenj:
				apply_impulse(Vector2(0,-500))	
			
		
		
	anitee += delta
	
	$Node2D.scale.y = 1.0 + 0.1*$PinJoint2D/RigidBody2D.position.y
	$Node2D.scale.x = 1.0 - float(!onsomething)*0.2*abs($PinJoint2D/RigidBody2D.position.x) - 0.04*$PinJoint2D/RigidBody2D.position.y
	if(talk and not talking):
		var children = get_parent().get_child(3).get_children()
		print(len(children))
		for slime in children:
			if(slime.vis):
				slime.find_child("input").visible = true
				slime.find_child("suggest").visible = false
				var Editor:TextEdit = slime.find_child("editor")
				Editor.grab_focus()
				talking = true
				rwkv.loadContext(slime.buildPrompt())
				print(rwkv.forward(20,0.8,0.6))
	if escape and talking:
		var children = get_parent().get_child(3).get_children()
		print(len(children))
		for slime in children:
			if(slime.vis):
				slime.find_child("input").visible = false
				slime.find_child("suggest").visible = true
				talking = false
				
	if enter and talking:
		var children = get_parent().get_child(3).get_children()
		print(len(children))
		for slime in children:
			if(slime.vis):
				var Editor:TextEdit = slime.find_child("editor")
				rwkv.loadContext(Editor.text+"\n\n"+slime.Ndame+":")
				slime.find_child("npcout").text = rwkv.forward(30,0.8,0.7)
				
func _on_floor_body_entered(body):
	onsomething = true
	timeout = 5

func _on_floor_body_exited(body):
	onsomething = false
	
