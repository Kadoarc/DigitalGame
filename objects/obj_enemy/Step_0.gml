/*(
switch(state)
{
	
	case "chase":
	#region Chase State
	set_state_sprite(sEnemy_run, 0.4,0);
	if not instance_exists(oPlayer) exit;
	
	image_xscale = sign(obj_enemy.x -x);
	if image_xscale ==0
	{
	image_xscale = 1;	
	}
	var direction_facing = image_xscale;
	var distance_to_player = point_distance(x,y,oPlayer.x, oPlayer.y);
	if distance_to_player <= attack_range
	{
		state = "attack";
		
	}
	else
	{
		move_and_collide(direction_facing * chase_speed,0);
	}
	#endregion
	break;
	
	
	case "attack":
	#region Attack State
	
	
	#endregion
	break;
}
*/
if (place_meeting(x+hsp,y,oSolid))
{
	var onepixel = sign(hsp);
	while (!place_meeting(x+onepixel,y,oSolid)) x += onepixel;
	hsp = 0;
	hsp_frac = 0;
}
//Horizontal Move
x += hsp;

var_distance = distance_to_object(oPlayer);
var_follow_range = 42;
var_speed = 1;

if (var_distance <= var_follow_range)
{
mp_potential_step(0, oPlayer.y, var_speed, false);	
}



