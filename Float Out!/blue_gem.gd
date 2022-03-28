extends Area2D

signal gem_collected


func _on_gem_body_entered(body):
	$AnimationPlayer.play("bounce")
	emit_signal("gem_collected")
	set_collision_mask_bit(0, false)
	# Play pickup sound
	$soundGemCollect.play()



func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()    # Deletes this object
