extends Node2D

@export var Name = ""
@export var likes:Array[String] = []
@export var dislikes:Array[String] = []
@export var secrets:Array[String] = []

var vis = 0
var myagent
# Called when the node enters the scene tree for the first time.
func _ready():
	$textbox/npcout.text = "Hello..."
	$AnimatedSprite2D.play("default")
	vis = 0
	

func buildPrompt():
	return """<|endoftext|># Instruction:\n you are an NPC in the city of slimes. your name is Alice
There is an election coming up, and potential candidates are approaching you to try and gain your vote.
You enjoy """+",".join(likes)+"""
You dislike """+",".join(dislikes)+"""
You know the following secrets: """+",".join(secrets)+"""

Look, a candidate approaches! see if he can convince you to give you his vote.
if he convinces you, say '[I am convinced]'

# Instruction:

Converse with the candidate and assess his capabilities.

# Chatlog
Alice: Hello!
"""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$textbox.modulate = lerp($textbox.modulate, Color8(255,255,255,vis), 0.1)


func _on_area_2d_body_entered(body):
	vis = 255


func _on_area_2d_body_exited(body):
	vis = 0
