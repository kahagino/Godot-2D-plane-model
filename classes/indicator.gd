extends Panel	
class_name Indicator

enum displayed_infos{ALTITUDE, AIRSPEED, GFORCE, AOA, VSPEED}

export(int) var nb_of_graduation = 12
export(float) var scale = 2.0
export(Vector2) var initial_axis = Vector2.UP

export(bool) var show_big_needle = true
export(bool) var show_light_needle = true

export(int, -360, 0) var angle_from = 0
export(int, 0, 360) var angle_to = 360

onready var label = get_node("Label")

export(displayed_infos) var displayed_info
var info = 0


func _ready():
	initial_axis = initial_axis.normalized() # make sure length is one
	
	angle_from = deg2rad(angle_from)
	angle_to = deg2rad(angle_to)
	

func _process(_delta):
	if displayed_info == displayed_infos.ALTITUDE:
		info = -Global.playerNode.position.y
	
	elif displayed_info == displayed_infos.AIRSPEED:
		info = Global.playerNode.linear_velocity.length()
	
	elif displayed_info == displayed_infos.GFORCE:
		info = Global.playerNode.get_vertical_g_force(Global.playerNode.acc)
		var g_text  = "%+3.1f" % info + " g"
		label.text = g_text
	
	elif displayed_info == displayed_infos.AOA:
		info = lerp(info, -Global.playerNode.get_aoa(), 0.1)
	
	elif displayed_info == displayed_infos.VSPEED:
		info = lerp(info, Global.playerNode.linear_velocity.y, 0.1)
		
	update()


func _draw():
	var center_offset:Vector2 = rect_size/2

	#draw_arc(center_offset, rect_size.y/2 - rect_size.y/4, 0.0, 2*PI, 32, Color.black, rect_size.y/2.4, true)
	
	# draw x1 needle
	if show_light_needle:
		draw_line(center_offset, center_offset + rect_size.y/3.8 * initial_axis.rotated(0.001 * scale * info), MyColors.mainBright, 1.0, true)
	
	# draw x10 needle
	if show_big_needle:
		draw_line(center_offset, center_offset + rect_size.y/4.8 * initial_axis.rotated(0.001*scale/nb_of_graduation * info), MyColors.mainBright, 2.0, true)

	# draw graduations
	var di
	if nb_of_graduation > 0: # avoid division by zero
		di = (angle_to - angle_from)/(nb_of_graduation)
	var dir = 0.35 * rect_size.y * initial_axis.rotated(angle_from)
	for i in range(nb_of_graduation +1):
		if i % 2 == 0:
			draw_line(center_offset + 0.8 * dir.rotated(i * di), center_offset + dir.rotated(i * di), MyColors.mainBright, 1.0, true)
		else:
			draw_line(center_offset + 0.9 * dir.rotated(i * di), center_offset + dir.rotated(i * di), MyColors.mainBright, 1.0, true)
