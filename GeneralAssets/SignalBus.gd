extends Node


signal enemy_marked(enemy_ref:Enemy)
signal unmark_enemy()
signal  player_dead
signal despawn_all
signal prop_marked(prop:RigidBody2D)
signal unmark_prop
signal reset_game
signal set_checkpoint(checkpoint_position:Vector2)
signal pass_level(next_level:PackedScene)
signal game_completed
signal despawn_orb
