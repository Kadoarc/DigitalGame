/// @desc Get Inputs
key_left = keyboard_check_direct(ord("A"));
key_right = keyboard_check_direct(ord("D"));
key_jump = keyboard_check_pressed(vk_space);
key_shoot = mouse_check_button_pressed(mb_left);
//Calc horizontal movement
walljumpdelay = max(walljumpdelay-1,0);
if (walljumpdelay == 0)
{
	var dir = key_right - key_left;
	hsp += dir * hsp_acc;
	if (dir == 0) 
	{
		var hsp_fric_final = hsp_fric_ground;
		if (!onground) hsp_fric_final = hsp_fric_air;
		hsp = Approach(hsp,0,hsp_fric_final);
	}
	hsp = clamp(hsp,-hsp_walk,hsp_walk);
}

//Wall jump
if (onwall != 0) && (!onground) && (key_jump)
{
	walljumpdelay = walljumpdelay_max;
	
	hsp = -onwall * hsp_wjump;
	vsp = vsp_wjump;
	
	hsp_frac = 0;
	vsp_frac = 0;
}

//Calc vertical movement
var grv_final = grv;
var vsp_max_final = vsp_max;
if (onwall != 0) && (vsp > 0)
{
	grv_final = grv_wall;
	vsp_max_final = vsp_max_wall;
}
vsp += grv_final;
vsp = clamp(vsp,-vsp_max_final,vsp_max_final);

//Ground Jump
if (jumpbuffer > 0)
{
	jumpbuffer--;
	if (key_jump)
	{
		jumpbuffer = 0;
		vsp = vsp_jump;
		vsp_frac = 0;
	}
}
vsp = clamp(vsp,-vsp_max,vsp_max)

//Dump fractions and get final integer speeds
hsp += hsp_frac;
vsp += vsp_frac;
hsp_frac = frac(hsp);
vsp_frac = frac(vsp);
hsp -= hsp_frac;
vsp -= vsp_frac;

//Horizontal Collision
if (place_meeting(x+hsp,y,oSolid))
{
	var onepixel = sign(hsp);
	while (!place_meeting(x+onepixel,y,oSolid)) x += onepixel;
	hsp = 0;
	hsp_frac = 0;
}
//Horizontal Move
x += hsp;

//Vertical Collision
if (place_meeting(x,y+vsp,oSolid))
{
	var onepixel = sign(vsp);
	while (!place_meeting(x,y+onepixel,oSolid)) y += onepixel;
	vsp = 0;
	vsp_frac = 0;
}
//Vertical Move
y += vsp;

//Calc current status
onground = place_meeting(x,y+1,oSolid);
onwall = place_meeting(x+1,y,oWall) - place_meeting(x-1,y,oWall);
if (onground) jumpbuffer = 6;

//Adjust sprite
image_speed = .6;
if (hsp != 0) image_xscale = sign(hsp);
if (!onground)
{
	if (onwall != 0)
	{
		sprite_index = sPlayer_wall;
		image_xscale = onwall;
		
		var side = bbox_left;
		if (onwall == 1) side = bbox_right;
		dust++;
		if ((dust > 2) && (vsp > 0)) with (instance_create_layer(side,bbox_top,"Behind",oDust))
		{
			other.dust = 0;
			hspeed = -other.onwall*0.5;
		}
	}
	else
	{
		dust = 0;
		sprite_index = sPlayer_air;
		image_speed = 0;
		image_index = (vsp > 0);
	}
} 
else 
{
	if (hsp != 0) sprite_index = sPlayer_run; else sprite_index = sPlayer;
}

if(key_shoot)
{
	newBullet = instance_create_layer(x+12*oPlayer.image_xscale,y+1,layer,oBullet);
	newBullet.hspeed = 8*oPlayer.image_xscale;
	newBullet.image_angle+=6;
	
	
}

if collision_circle(x,y,64,obj_enemychoice, true, true)
{
	if(keyboard_check_pressed(ord("M")))
	{
		messageGiver = collision_circle(x,y,64, obj_enemychoice, true, true);
		PCTalking = self;
		isTalking = true;
		scrDialogue();
	}
}