#
# This is an attempt to recreate SHAMUS.COM (32768 PC executable)
# svofski 2023
#
# Shamus by Cathryn Mataga
#
# PC version by ???
#

extends Panel


var texture : ImageTexture
var textureImage : Image

onready var cgatr : TextureRect = $CgaTextureRect

# cga bits, 2 bits per pixel, interlaced
var b800 : PoolByteArray

# truecolor
var truecolor : PoolByteArray
var intarray : PoolIntArray

const cga_stride : int = 320/4
const cga_field_size : int = cga_stride * 100


var shamuscom : PoolByteArray
const PATTERN_TABLE : int = 0x0105

const GAMESTATE_A : int = 0x6b70
const GAMESTATE_B : int = 0x6a70
# game map flags
const SCARY_ROOM_BIT = 2	# gamestate_b 

const POWERUP_POSITIONS_TABLE: int = 0x7523  # x,y
const PLACEMENT_OFFSET: int = 0x7535

const HWALL_X : int = 0x6cf0
const HWALL_Y : int = 0x6cf6
const VWALL_X : int = 0x6cfc
const VWALL_Y : int = 0x6d02
const ROOM_LINK_TABLE : int = 0x6c70

const LOCKED_ROOM_TABLE_SIZE = 9
const LOCKED_ROOM_TABLE : int = 0x7559 # 9 bytes

const KEYHOLE_TYPE_TABLE_SIZE = 9
const KEYHOLE_TYPE_TABLE: int = 0x458f

const KEY_LOCATIONS_TABLE_SIZE = 10
const KEY_LOCATIONS_TABLE: int = 0x45a1

const SPR_MORLEVAN : int = 0x6d48
const SPR_COLON : int = 0x6e08
const SPR_3X8_0 : int = 0x6e20

const SPR_EXTRALIFE: int = 0x72cd
const SPR_EXTRALIFE_W = 3
const SPR_EXTRALIFE_H = 6 # top only
const SPR_EXTRALIFE_F1 = 0x12
const SPR_EXTRALIFE_F2 = 0x24
const SPR_EXTRALIFE_F3 = 0x36

const SPR_KEY_W = 4
const SPR_KEY_H = 12
const SPR_KEY: int = 0x7315

const SPR_KEYHOLE_W: int = 3
const SPR_KEYHOLE_H: int = 13
const SPR_KEYHOLE: int = 0x73a5

const SPR_MYSTERY_W = 3
const SPR_MYSTERY_H = 12
const SPR_MYSTERY: int = 0x7285
const SPR_MYSTERY_F2: int = 0x24 # offset to second frame

const SPR_CLEAR_2X4_W = 2
const SPR_CLEAR_2X4_H = 4
const SPR_CLEAR_2X4 = 0x6d08 # rare source of properly clean bits

const SPR_EXPL_1X = 0x38d0 # 4x8
const SPR_EXPL_2X = 0x38f0 # 
const SPR_EXPL_3X = 0x3910
const SPR_EXPL_4X = 0x3928


const ANIMATION_SPEED_MYSTERY = 5
const ANIMATION_SPEED_EXTRALIFE = 4

# monstrebi

const MONSTERKIND_SPIRALDRONE2 = 0
const MONSTERKIND_SPIRALDRONE3 = 1
const MONSTERKIND_ROBODROID = 2
const MONSTERKIND_SNAPJUMPER = 3

var MONSTER_PROCESSING_LIMIT = 0x12 # or 0x0d

const SPR_SPIRALDRONE_W = 4
const SPR_SPIRALDRONE_H = 8
const SPR_SPIRALDRONE2 = [0x6f10, 0x6f10 + 32 * 1, 0x6f10 + 32 * 2, 0x6f10 + 32 * 3, 0x6f10 + 32 * 4, 0x6f10 + 32 * 5]
const SPR_SPIRALDRONE3 = [0x6fd0, 0x6fd0 + 32 * 1, 0x6fd0 + 32 * 2, 0x6fd0 + 32 * 3, 0x6fd0 + 32 * 4, 0x6fd0 + 32 * 5]

const SPR_ROBODROID_W = 4
const SPR_ROBODROID_H = 8
const SPR_ROBODROID = [0x7090, 0x7090 + 32 * 1, 0x7090 + 32 * 2, 0x7090 + 32 * 3, 0x7090 + 32 * 4, 0x7090 + 32 * 5]

const SPR_SNAPJUMPER_W = 3
const SPR_SNAPJUMPER_H = 8
const SPR_SNAPJUMPER = [0x718e]

const SPR_SJEYES_W = 3
const SPR_SJEYES_H = 3
const SPR_SJEYES = 0x71a6 # 3x20
const SJ_EYE_OFFSETS = 0x71e5


const PAT4X8_VSTRIPES : int = 0x66da

# powerup kinds, stored in gamestate_a & 3
const POWERUP_EXTRALIFE = 1
const POWERUP_MYSTERY = 2
const POWERUP_KEY = 3
const POWERUP_KEYHOLE = 4

var patspr_a: int
var patspr_b: int

var wallpat_a: int
var wallpat_b: int
var wallpat_n: int

var advanced_mode: int = 0
var room_num: int = 0
var powerup_present: int = 0
var time_until_shadow: int = 0
var special_monster_flag: int = 0
var slit_y: int = 0
var door_location: int = 0
var animation_counter: int = 0
var picked_powerup_kind: int = 0

var collision: bool = false

var lives_remaining: int = 5

var player_x: int = 0
var player_y: int = 0
var player_entry_x: int = 0
var player_entry_y: int = 0
var found_keys = [255, 255, 255]

const SPR_SHAMUS_W = 4
const SPR_SHAMUS_H = 12
const SPR_SHAMUS = [0x6710, 0x6740, 0x6770, 0x67a0, 0x67d0, 0x6800, 0x6830, 0x6860, 0x6890]
const SPR_SHAMUS_NOHAT = 0x68c0

const LOOKAT_OFFSET = 0x2b0f

var sprite_ptr: int = SPR_SHAMUS[0]

var powerup_kind: int = 0
var powerup_x: int = 0
var powerup_y: int = 0
var powerup_animation_offset: int = 0
var powerup_animation_delay: int = 0

var room_locked: bool = false
var sliding_freq: int = 0

var randomword: int = 0

class foe_data:
	var kind: int
	var y: int
	var x: int
	var sprite_ofs: int # relative to sprite[0]
	var dir: int		# moving direction
	var anim_ctr: int

var num_monsters: int = 0
var monster_array = []


var monster_kind = 0
var monster_sprite_ofs = 0
var monster_anim_ctr = 0
var monster_dir = 0
var lookat_x = 0
var lookat_y = 0
var monster_x = 0
var monster_y = 0


# player directions
const DIR_0: int = 0
const DIR_NE: int = 1
const DIR_N: int = 2
const DIR_NW: int = 3
const DIR_W: int = 4
const DIR_E: int = 5
const DIR_SW: int = 6
const DIR_S: int = 7
const DIR_SE: int = 8

var player_dir: int = DIR_0

var available_exits: int = 0

const JOY_UP = 0
const JOY_DOWN = 1
const JOY_LEFT = 2
const JOY_RIGHT = 3
const JOY_FIRE = 4
var joystick = [0, 0, 0, 0, 0]

# room exit flags bits (not for the actual game)
const EXIT_NORTH = 1
const EXIT_SOUTH = 2
const EXIT_EAST = 4
const EXIT_WEST = 8

func load_data() -> void:
	var file = File.new()
	if file.open("res://assets/shamus.tres", File.READ) == OK:
		shamuscom = file.get_buffer(file.get_len())
		
func get_word(addr: int) -> int:
	addr = addr - 0x100
	return shamuscom[addr] | (shamuscom[addr + 1] << 8)

func get_byte(addr: int) -> int:
	addr = addr - 0x100
	return shamuscom[addr]
	
func get_gamestate_a(room: int) -> int:	
	return shamuscom[GAMESTATE_A - 0x100 + room]
	
func get_gamestate_b(room: int) -> int:	
	return shamuscom[GAMESTATE_B - 0x100 + room]

func set_gamestate_a(room: int, val: int) -> void:
	shamuscom[GAMESTATE_A - 0x100 + room] = val
	
func set_gamestate_b(room: int, val: int) -> void:
	shamuscom[GAMESTATE_B - 0x100 + room] = val


# ABGR
const cga_palette_bob = [0xff000000, 0xff00aa00, 0xff0000aa, 0xff0055aa]

const cga_palette: PoolIntArray = PoolIntArray(cga_palette_bob)

var spb = StreamPeerBuffer.new()

func b800_to_truecolor():
	var even_index: int
	var odd_index: int
	var tc_index: int
	var tc_index2: int
	
	var b : int
	var p1 : int
	var p2 : int
	var p3 : int
	var p4 : int
	var xofs : int
	
	for y in range(100):
		even_index = y * cga_stride
		odd_index = y * cga_stride + cga_field_size
		
		tc_index = y * 320 * 2
		tc_index2 = tc_index + 320
		for x in range(cga_stride):
			b = b800[x + even_index]	# get cga bits, 4 pixels
			xofs = x * 4
			intarray[tc_index + xofs + 0] = cga_palette[(b & 0xc0) >> 6]
			intarray[tc_index + xofs + 1] = cga_palette[(b & 0x30) >> 4]
			intarray[tc_index + xofs + 2] = cga_palette[(b & 0x0c) >> 2]
			intarray[tc_index + xofs + 3] = cga_palette[b & 0x03]
			b = b800[x + odd_index]		# get cga bits, 4 pixels
			intarray[tc_index2 + xofs + 0] = cga_palette[(b & 0xc0) >> 6]
			intarray[tc_index2 + xofs + 1] = cga_palette[(b & 0x30) >> 4]
			intarray[tc_index2 + xofs + 2] = cga_palette[(b & 0x0c) >> 2]
			intarray[tc_index2 + xofs + 3] = cga_palette[b & 0x03]
	
	# unfortunately Godot seems to have no way of casting arrays that's less insane
	# this one is okay for testing purposes
	spb.seek(0)
	spb.put_var(intarray)
	
	truecolor = spb.data_array.subarray(12, -1)


var mem_image
var mem_texture

func updateTexture():
	# dummy texture
	if textureImage == null:
		textureImage = Image.new()
		textureImage.create_from_data(320,200,false,Image.FORMAT_RGBA8,truecolor)

	if texture == null:
		texture = ImageTexture.new()
		texture.create(320, 200, Image.FORMAT_RGBA8, Texture.FLAG_VIDEO_SURFACE) # no filtering
		cgatr.texture = texture
		
	if mem_image == null:
		mem_image = Image.new()
		mem_image.create(80, 200, false, Image.FORMAT_R8)
	if mem_texture == null:
		mem_texture = ImageTexture.new()
		mem_texture.create(80, 200, Image.FORMAT_R8, 
			Texture.FLAG_VIDEO_SURFACE)

	$CgaTextureRect.material.set_shader_param("b800", mem_texture)

	mem_image.data.data = b800
	mem_texture.set_data(mem_image)

func cls():
	for i in b800.size():
		b800[i] = 0

func get_cga_addr(x: int, y: int) -> int:
	return x + (y >> 1) * cga_stride + cga_field_size * (y & 1)
	
func setpixel(x : int, y : int, col : int):
	var addr = get_cga_addr(x >> 2, y)
	var shift = 2 * (3 - (x & 3))
	
	b800[addr] = b800[addr] | ((col & 3) << shift)

func xor_pattern(x0: int, y0: int, w: int, h: int, src: int):
	var si = src - 0x100
	for y in h:
		for x in w:
			b800[get_cga_addr(x + x0, y + y0)] ^= shamuscom[si]
			si += 1

func draw_pattern(x0: int, y0: int, w: int, h: int, src: int):
	var si = src - 0x100
	for y in h:
		for x in w:
			b800[get_cga_addr(x + x0, y + y0)] = shamuscom[si]
			si += 1

func ground(x0, y0, w, h, xrepeats, yrepeats, src1, src2):
	var y = y0
	var src = src1
	while yrepeats > 0:
		for xr in xrepeats:
			draw_pattern(x0 + xr * w, y, w, h, src)
		yrepeats -= 1
		y += h
		if src == src1:
			src = src2
		else:
			src = src1

func xground(x0, y0, w, h, xrepeats, yrepeats, src1, src2):
	var y = y0
	var src = src1
	while yrepeats > 0:
		for xr in xrepeats:
			xor_pattern(x0 + xr * w, y, w, h, src)
		yrepeats -= 1
		y += h
		if src == src1:
			src = src2
		else:
			src = src1

func movsprite(x, y, w, h, src):
	return ground(x, y, w, h, 1, 1, src, src)
			
func xorsprite(x, y, w, h, src):
	return xground(x, y, w, h, 1, 1, src, src)

func xorsprite_collision(x0, y0, w, h, src):
	collision = false
	var si = src - 0x100
	for y in h:
		for x in w:
			if b800[get_cga_addr(x + x0, y + y0)] & 0xaa != 0:
				collision = true
			b800[get_cga_addr(x + x0, y + y0)] ^= shamuscom[si]
			si += 1


func xorsprite_collision_sj(x0, y0, w, h, src):
	collision = false
	var si = src - 0x100
	for y in h:
		for x in w:
			var al = shamuscom[si]
			si += 1
			b800[get_cga_addr(x + x0, y + y0)] ^= al
			if not collision:
				if al & 0xc0 != 0:
					al |= 0xc0
				if al & 0x30 != 0:
					al |= 0x30
				if al & 0x0c != 0:
					al |= 0x0c
				if al & 0x03 != 0:
					al |= 0x03
				if (b800[get_cga_addr(x + x0, y + y0)] & al) & 0xaa != 0:
					collision = true

func xorplayer(src):
	xorsprite(player_x, player_y, SPR_SHAMUS_W, SPR_SHAMUS_H, src)

func room_to_pattern(room_n: int) -> void:
	#pattern_table
	var n = room_n
	if room_n > 8:
		n = room_n >> 3
	patspr_a = get_word(PATTERN_TABLE + n * 2)
	patspr_b = patspr_a + 0x20
	if room_n > 127:
		patspr_a = 0x65ca
		patspr_b = 0x65ea

func room_to_wallpat(room_n: int) -> void:
	if room_n < 0x26:
		wallpat_a = 0x660a
		wallpat_b = 0x660a
		wallpat_n = 1
	elif room_n < 0x43:
		wallpat_a = 0x665a
		wallpat_b = 0x662a
		wallpat_n = 2
	elif room_n < 0x5d:
		wallpat_a = 0x667a
		wallpat_b = 0x663a
		wallpat_n = 3
	elif room_n < 0x7f:
		wallpat_a = 0x667a
		wallpat_b = 0x663a
		wallpat_n = 4
	else:
		wallpat_a = 0x66ba
		wallpat_b = 0x66ba
		wallpat_n = 4

const ANIM_SPIRALDRONE2 = 0x74fe
const ANIM_SPIRALDRONE3 = 0x74da
const ANIM_ROBODROID = 0x74b6

var check_move_result: int = 0

func draw_robodroid_tail() -> void:
	pass
		
func testw(waddr: int, mask: int) -> int:
	var w = b800[waddr] | (b800[waddr + 1] << 8)
	return w & mask
	
func check_area_around_monster(xoffset, mask) -> bool:
	var bx = get_cga_addr(0, monster_y) + monster_x + xoffset
	for line in [0, 0x50, 0xa0, 0xf0, 0x140]:
		if testw(bx + line, mask) != 0:
			return false
	bx = get_cga_addr(0, monster_y - 1) + monster_x + xoffset
	for line in [0, 0x140]:
		if testw(bx + line, mask) != 0:
			return false
	return true
		
# monster to the left of target	
func find_new_dir_monster_left() -> int:	
	if monster_kind == MONSTERKIND_SPIRALDRONE2:
		var x2 = (monster_x + lookat_x) >> 1
		if b800[get_cga_addr(x2, monster_y)] & 0xaa != 0:
			return 0
		
	if monster_sprite_ofs <= 0x40:
		# left-leaning sprite
		if check_area_around_monster(3, 0x0aa0):
			check_move_result = 4
			return 0x18 # i'm sure this was worth it
	else:
		# right-leaning sprite
		if check_area_around_monster(4, 0xaaa0):
			check_move_result = 4
			return 0x18
			
	return 0
		
# monster to the right of target	
func find_new_dir_monster_right() -> int:
	if monster_kind == MONSTERKIND_SPIRALDRONE2:
		var x2 = (monster_x + lookat_x) >> 1
		if b800[get_cga_addr(x2, monster_y)] & 0xaa != 0:
			return 0

	if monster_sprite_ofs <= 0x40:
		# left-leaning sprite
		if check_area_around_monster(-2, 0x0aaa):
			check_move_result = 3
			return 0xc
	else:
		# right-leaning sprite
		var bx = get_cga_addr(0, monster_y) + monster_x
		if check_area_around_monster(0, 0x0aa0):
			check_move_result = 3
			return 0xc
	return 0

func find_new_direction() -> int:
	if monster_x == lookat_x:
		return 0
		
	if monster_x < lookat_x:
		return find_new_dir_monster_left()
	else:
		return find_new_dir_monster_right()


func can_monster_go_up() -> bool:
	for line in 2:
		if testw(get_cga_addr(monster_x, monster_y - 1 - line * 2), 0xaaaa) != 0:
			return false
		if testw(get_cga_addr(monster_x + 2, monster_y - 1 - line * 2), 0xaaaa) != 0:
			return false
	return true
	
func can_monster_go_down() -> bool:
	for line in 2:
		if testw(get_cga_addr(monster_x, monster_y + 8 + line * 2), 0xaaaa) != 0:
			return false
		if testw(get_cga_addr(monster_x + 2, monster_y + 8 + line * 2), 0xaaaa) != 0:
			return false
	return true

func try_vert_move() -> void:
	if monster_y == lookat_y:
		return
	if monster_y > lookat_y and monster_y > 0:
		if can_monster_go_up():
			check_move_result = 1
			monster_y -= 1
	if monster_y < lookat_y and monster_y < 168:
		if can_monster_go_down():
			check_move_result = 2
			monster_y += 1

func retarget_snapjumper():
	pass
	
func rand_1_to_4() -> int:
	ror_randomword()
	return (randomword & 3) + 1

func can_snapjump_to(x, y) -> bool:
	var addr = get_cga_addr(x, y)
	var yes = testw(addr - 1, 0x00aa) == 0 and testw(addr, 0xaaaa) == 0 and testw(addr + 2, 0xaaaa) == 0
	if yes:
		addr = get_cga_addr(x, y + 1)
		yes = testw(addr - 1, 0x00aa) == 0 and testw(addr, 0xaaaa) == 0 and testw(addr + 2, 0xaaaa) == 0
	return yes

func try_snapjump_y():
	var jump_dist = rand_1_to_4() << 1
	if monster_y == lookat_y:
		return
	if monster_y > lookat_y:
		# sjw below
		var testy = monster_y - jump_dist
		if can_snapjump_to(monster_x, testy):
			check_move_result = 1
			monster_y = testy
			if monster_y < 0:
				monster_y = 0
	else:
		# sjw above
		var testy = monster_y + jump_dist
		if can_snapjump_to(monster_x, testy):
			check_move_result = 2
			monster_y = testy
			if monster_y > 170:
				monster_y = 170

# this logic is different to the game because the game code here is completely nuts
func can_sjw_go(x, y) -> bool:
	xorsprite_collision(x, y, 3, 8, SPR_SNAPJUMPER[0])
	xorsprite(x, y, 3, 8, SPR_SNAPJUMPER[0])
	return not collision
		
func try_snapjump_x():
	var jump_dist = rand_1_to_4() - 1
	if jump_dist == 0:
		return
	if monster_x == lookat_x:
		return
	if monster_x > lookat_x:
		# sjw to the right
		if can_sjw_go(monster_x - jump_dist - 1, monster_y):
			monster_x -= jump_dist
			if monster_x < 0:
				monster_x = 0
			check_move_result = 3
	else:
		# sjw to the right
		if can_sjw_go(monster_x + jump_dist + 1, monster_y):
			monster_x += jump_dist
			if monster_x > 77:
				monster_x = 77
			check_move_result = 4

func explode_monster():
	if monster_kind < 0x14:
		play_sound(0xb600 | ((randomword & 0x7f + 0x122) >> 8))
		num_monsters -= 1
		if num_monsters == 0:
			convert_score_2()
		convert_score_1()
		display_score()
		xorsprite(monster_x, monster_y, 4, 8, SPR_EXPL_1X)
		monster_kind = 0x14
		return
	if monster_kind < 0x1e:
		play_sound((randomword >> 1 & 0x7f) + 300)
		xorsprite(monster_x, monster_y, 4, 8, SPR_EXPL_1X)
		xorsprite(monster_x, monster_y, 4, 8, SPR_EXPL_2X)
		monster_kind = 0x1e
		return
	if monster_kind < 0x28:
		play_sound((randomword >> 2 & 0xff) + 200)
		xorsprite(monster_x, monster_y, 4, 8, SPR_EXPL_2X)
		monster_anim_ctr = 0
		play_sound(0)
		return
	# 0x28 -- snap jumper 
	if monster_kind < 0x32:	
		xorsprite(monster_x, monster_y, 3, 8, SPR_EXPL_3X)
		monster_kind = 0x32
		ror_randomword()
		play_sound((randomword & 0x7f) + 0x190)
		return
	if monster_kind < 0x33:
		play_sound(0x1770)
		num_monsters -= 1
		if num_monsters == 0:
			convert_score_2()
		convert_score_1()
		display_score()
		play_sound(0x186)
		xorsprite(monster_x, monster_y, 3, 8, SPR_EXPL_3X)
		xorsprite(monster_x, monster_y, 3, 8, SPR_EXPL_4X)
		monster_kind = 0x3c
		return
		
	xorsprite(monster_x, monster_y, 3, 8, SPR_EXPL_4X)
	play_sound(0x15e)
	monster_anim_ctr = 0
	play_sound(0)
	return

var glob_current_monster: int = 0

func save_monster(m: foe_data) -> void:
	if monster_kind > MONSTERKIND_SNAPJUMPER:
		print("m: ", glob_current_monster, " kind=%x" % m.kind, " becomes=%x" % monster_kind)
		m.kind = monster_kind
	m.x = monster_x
	m.y = monster_y
	m.dir = monster_dir
	m.anim_ctr = monster_anim_ctr

func process_monsters():
	var monster_width = 4
	var monster_height = 8
	
	var evil_count = MONSTER_PROCESSING_LIMIT
	ror_randomword()
	for current_monster in 25:
		glob_current_monster = current_monster
		var anim_offsets_ptr = 0
		evil_count -= 1
		if evil_count < 0:
			return
		# bullet shooting stuff here
		if monster_array[current_monster].kind == 0xff:
			update_randomword()
			return
		
		var m: foe_data = monster_array[current_monster]
		if m.anim_ctr == 0:
			# idle? 
			continue
		
		# set global monster temporaries	
		monster_anim_ctr = m.anim_ctr # work on copy
		monster_dir = m.dir
		monster_kind = m.kind
		monster_sprite_ofs = m.sprite_ofs
		lookat_x = player_x
		lookat_y = player_y
		monster_x = m.x
		monster_y = m.y
		
		var si = 0
		match m.kind:
			MONSTERKIND_SPIRALDRONE2:
				anim_offsets_ptr = ANIM_SPIRALDRONE2
				si = SPR_SPIRALDRONE2[0]
				pass
			MONSTERKIND_SPIRALDRONE3:
				anim_offsets_ptr = ANIM_SPIRALDRONE3
				si = SPR_SPIRALDRONE3[0]
				if powerup_present:
					lookat_x = powerup_x
					lookat_y = powerup_y
					
					lookat_x = (lookat_x + get_byte(LOOKAT_OFFSET + m.dir)) & 0xff
					
					# this is very strange
					var al = get_byte(LOOKAT_OFFSET + m.dir + 1)					
					if lookat_y < 0x10:
						lookat_y = (lookat_y + al) & 0xff
						if lookat_y & 0x80 != 0:	# cs:2dd4 actually checking if it's not a negative byte 
							lookat_y = 0
					else:
						lookat_y = (lookat_y + al) & 0xff 
						
					monster_anim_ctr -= 1
					if monster_anim_ctr == 0:
						ror_randomword()
						monster_anim_ctr = (randomword & 0xf) + 5
						monster_dir = ((randomword >> 8) & 7) << 1
					
				pass
			MONSTERKIND_ROBODROID:
				anim_offsets_ptr = ANIM_ROBODROID
				si = SPR_ROBODROID[0]
				pass
			MONSTERKIND_SNAPJUMPER:
				monster_width = 3
				anim_offsets_ptr = 0
				si = SPR_SNAPJUMPER[0]
			#0x28:
			
		if m.kind > MONSTERKIND_SNAPJUMPER:
			if monster_anim_ctr > 0:
				explode_monster()
				save_monster(m)
			continue
				
		if m.kind == MONSTERKIND_SNAPJUMPER:
			xorsprite_collision_sj(monster_x, monster_y, monster_width, monster_height, si + m.sprite_ofs)
			xorsprite(monster_x, monster_y + 1, SPR_SJEYES_W, SPR_SJEYES_H, SPR_SJEYES + get_byte(monster_dir + SJ_EYE_OFFSETS))
			
			if collision:
				m.kind = 0x28 # mark for exploding later
				continue
			
			if monster_anim_ctr & 1 != 0: # cs:3ec5
				if monster_anim_ctr == 7:
					retarget_snapjumper()
				check_move_result = 0
				if (randomword >> 8) & 1 == 0:
					try_snapjump_y()
					if check_move_result == 0:
						try_snapjump_x()
				else:
					try_snapjump_x()
					if check_move_result == 0:
						try_snapjump_y()
				
			xorsprite(monster_x, monster_y, monster_width, monster_height, si + m.sprite_ofs)
			monster_anim_ctr -= 1
			if monster_anim_ctr == 0:
				monster_anim_ctr = (randomword & 7) + 5
				ror_randomword()
				monster_dir = randomword & 15
			xorsprite(monster_x, monster_y +1, SPR_SJEYES_W, SPR_SJEYES_H, SPR_SJEYES + get_byte(monster_dir + SJ_EYE_OFFSETS))				
			save_monster(m)
			continue
				
		# L2e61_proceed_monster
		
		# regular monstre
		# wipe old sprite
		xorsprite(monster_x, monster_y, monster_width, monster_height, si + m.sprite_ofs)
		if m.kind == MONSTERKIND_ROBODROID:
			draw_robodroid_tail()

		check_move_result = 0
		var newdir_result = 0
		if randomword & 1 == 0:
			newdir_result = find_new_direction()
			if check_move_result == 0:
				try_vert_move()
		else:
			try_vert_move()
			if check_move_result == 0:
				newdir_result = find_new_direction()
				
		if anim_offsets_ptr == 0:
			continue
				
		var bx = monster_sprite_ofs # 0, $20, $40, $80..
		bx >>= 4
		bx += newdir_result
		bx = bx + anim_offsets_ptr
		var al = get_byte(bx)		# 2ede
		si += al
		monster_x = (m.x + get_byte(bx + 1)) & 0xff
		xorsprite_collision(monster_x, monster_y, monster_width, monster_height, si)
		if collision:
			monster_kind = 0xa
			xorsprite(monster_x, monster_y, monster_width, monster_height, si)
		if monster_width == 2:
			pass # some wtf? what has width 2?
		
		# save monster
		save_monster(m)
		m.sprite_ofs = al

func paint_bullets():
	pass
func process_shivs():
	pass
func move_bullets():
	pass
func check_shadow_entrance():
	pass
func open_locked_door():
	animation_counter = (animation_counter - 1) & 255
	if animation_counter & 1 == 0:
		sliding_freq = sliding_freq - 8
		play_sound(sliding_freq)
	movsprite(door_location, 2 * animation_counter + 0x40, SPR_CLEAR_2X4_W, 2, SPR_CLEAR_2X4)
		
func player_set_dir():
	player_dir = DIR_0
	if joystick[JOY_UP]:
		if joystick[JOY_LEFT]:
			player_dir = DIR_NW
		elif joystick[JOY_RIGHT]:
			player_dir = DIR_NE
		else:
			player_dir = DIR_N
	elif joystick[JOY_DOWN]:
		if joystick[JOY_LEFT]:
			player_dir = DIR_SW
		elif joystick[JOY_RIGHT]:
			player_dir = DIR_SE
		else:
			player_dir = DIR_S
	elif joystick[JOY_LEFT]:
		player_dir = DIR_W
	elif joystick[JOY_RIGHT]:
		player_dir = DIR_E
	
func anim_player(dx, dy, f1, f2) -> void:
	xorplayer(sprite_ptr)
	player_x += dx
	player_y += dy
	if sprite_ptr == SPR_SHAMUS[f1]:
		sprite_ptr = SPR_SHAMUS[f2]
	else:
		sprite_ptr = SPR_SHAMUS[f1]
	xorplayer(sprite_ptr)
		
func player_walk() -> void:
	match player_dir:
		DIR_0:
			anim_player(0, 0, 0, 0)
		DIR_NW:
			if player_y < 3:
				next_room_north()
			elif player_x < 1:
				next_room_west()
			else:
				anim_player(-1, -2, 5, 6)
		DIR_N:
			if player_y < 2:
				next_room_north()
			else:
				anim_player(0, -2, 1, 2)
		DIR_NE:
			if player_y < 3:
				next_room_north()
			elif player_x >= 0x4c:
				next_room_east()
			else:
				anim_player(1, -2, 7, 8)
		DIR_W:
			if player_x < 1:
				next_room_west()
			else:
				anim_player(-1, 0, 5, 6)
		DIR_E:
			if player_x >= 0x4c:
				next_room_east()
			else:
				anim_player(1, 0, 7, 8)
		DIR_SW:
			if player_y >= 162:
				next_room_south()
			elif player_x < 1:
				next_room_west()
			else:
				anim_player(-1, 2, 5, 6)
		DIR_S:
			if player_y >= 162:
				next_room_south()
			else:
				anim_player(0, 2, 3, 4)
		DIR_SE:
			if player_y >= 162:
				next_room_south()
			elif player_x >= 0x4c:
				next_room_east()
			else:
				anim_player(1, 2, 7, 8)

func process_player():
	player_set_dir()
	player_walk()

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	if special_monster_flag and powerup_present:
		animate_scary_room()
	
	check_powerup()
	process_monsters()
	paint_bullets()
	process_shivs()
	move_bullets()
	if time_until_shadow & 1 != 0:
		paint_bullets()
		move_bullets()	
	if time_until_shadow > 0 and powerup_present:
		animate_powerup()
	time_until_shadow -= 1
	check_shadow_entrance()
	
	if animation_counter > 0:
		if picked_powerup_kind == POWERUP_KEYHOLE:
			open_locked_door()
		
	process_player()
	
	updateTexture()

func open_room() -> void:
	ground(0, 0, 4, 8, 4, 7, patspr_a, patspr_b)
	ground(0x40, 0, 4, 8, 4, 7, patspr_a, patspr_b)
	ground(0, 0x78, 4, 8, 4, 7, patspr_a, patspr_b)
	ground(0x40, 0x78, 4, 8, 4, 7, patspr_a, patspr_b)
	
	# outer walls
	ground(0, 0x38, 4, 8, 4, 1, wallpat_a, wallpat_a)
	ground(0, 0x70, 4, 8, 4, 1, wallpat_a, wallpat_a)	
	ground(0x10, 0, 2, 8, 1, 8, wallpat_b, wallpat_b)
	ground(0x10, 0, 4, 8, 12, 1, wallpat_a, wallpat_a)
	ground(0x40, 0, 2, 8, 1, 7, wallpat_b, wallpat_b)
	ground(0x40, 56, 4, 8, 4, 1, wallpat_a, wallpat_a)
	ground(0x40, 0x70, 2, 8, 1, 8, wallpat_b, wallpat_b)
	ground(0x40, 0x70, 4, 8, 4, 1, wallpat_a, wallpat_a)
	ground(0x10, 0xa8, 4, 8, 12, 1, wallpat_a, wallpat_a)	
	ground(0x10, 0x70, 2, 8, 1, 8, wallpat_b, wallpat_b)
	
	available_exits = EXIT_EAST | EXIT_WEST

func clear_stats_area() -> void:
	pass

func draw_lives() -> void:
	pass

func junction_room(ah, al) -> void:
	if ah & 0x80 == 0:
		ground(0, 0, 4, 8, 0x14, 7, patspr_a, patspr_b)	# blocked north passage
	else:
		ground(0, 0, 4, 8, 8, 7, patspr_a, patspr_b)	# open north
		ground(0x30, 0, 4, 8, 8, 7, patspr_a, patspr_b)	#
		available_exits |= EXIT_NORTH 
	
	clear_stats_area()
	draw_lives()
	
	if al & 0x80 == 0:
		ground(0, 0x38, 4, 8, 8, 8, patspr_a, patspr_b)		# blocked west passage
	else:
		available_exits |= EXIT_WEST
		
	if al & 0x20 == 0:
		ground(0x30, 0x38, 4, 8, 8, 8, patspr_a, patspr_b)	# blocked east passage
	else:
		available_exits |= EXIT_EAST
		
	if ah & 0x80 != 0:
		ground(0, 0x78, 4, 8, 0x14, 7, patspr_a, patspr_b)	# blocked south passage
	else:
		ground(0,    0x78, 4, 8, 8, 7, patspr_a, patspr_b)	# open south
		ground(0x30, 0x78, 4, 8, 8, 7, patspr_a, patspr_b)
		available_exits |= EXIT_SOUTH
		
	if ah & 0x80 == 0:
		ground(0x20, 0x78, 2, 8, 1, 7, wallpat_b, wallpat_b)
		ground(0x2e, 0x78, 2, 8, 1, 7, wallpat_b, wallpat_b)
	else:
		ground(0x20, 0, 2, 8, 1, 8, wallpat_b, wallpat_b)
		ground(0x2e, 0, 2, 8, 1, 8, wallpat_b, wallpat_b)

	if al & 0x80 != 0:
		ground(0, 0x38, 4, 8, 4, 1, wallpat_a, wallpat_a)
		ground(0, 0x70, 4, 8, 4, 1, wallpat_a, wallpat_a)
	if al & 0x04 != 0:
		ground(0x30, 0x38, 4, 8, 8, 1, wallpat_a, wallpat_a)
		ground(0x30, 0x70, 4, 8, 8, 1, wallpat_a, wallpat_a)
		
func seal_room_left() -> void:
	ground(0, 0x40, 2, 8, 1, 6, wallpat_b, wallpat_b)
	door_location = 0

func seal_room_right() -> void:
	ground(0x4e, 0x40, 2, 8, 1, 6, wallpat_b, wallpat_b)
	door_location = 0x4e

func draw_hwall(n: int) -> void:
	var x = shamuscom[HWALL_X + n - 0x100]
	var y = shamuscom[HWALL_Y + n - 0x100]
	ground(x, y, 4, 8, 4, 1, wallpat_a, wallpat_a)

func draw_vwall(n: int) -> void:
	var x = shamuscom[VWALL_X + n - 0x100]
	var y = shamuscom[VWALL_Y + n - 0x100]
	ground(x, y, 2, 8, 1, 8, wallpat_b, wallpat_b)

func draw_inner_walls(al, ah) -> void:
	var c : int
	for n in 6:
		c = al & 0x80
		al <<= 1
		if c != 0:
			draw_hwall(5-n)

		c = ah & 0x80
		ah <<= 1
		if c != 0:
			draw_vwall(5-n)

func scary_room():
	time_until_shadow = 700
	special_monster_flag = 1
	slit_y = 7
	
	ground(0x1f, 8, 4, 8, 1, 0x14, PAT4X8_VSTRIPES, PAT4X8_VSTRIPES)
	ground(0x2f, 8, 4, 8, 1, 0x14, PAT4X8_VSTRIPES, PAT4X8_VSTRIPES)

func draw_num(n: int, x0: int, y: int, digits: int) -> void:
	var x = x0 + (digits - 1) * 3
	var s = str(n)
	var i = len(s) - 1
	while i >= 0:
		var rem = ord(s[i]) - ord('0')
		i -= 1
		ground(x, 0xc0, 3, 8, 1, 1, SPR_3X8_0 + rem * 24, SPR_3X8_0 + rem * 24)
		x -= 4

func draw_room_caption(n: int) -> void:
	var x = 1
	ground(x, 0xc0, 3, 8, 1, 1, SPR_MORLEVAN + 48, SPR_MORLEVAN + 48)
	x += 4
	ground(x, 0xc0, 3, 8, 1, 1, SPR_MORLEVAN + 24, SPR_MORLEVAN + 24)
	x += 4
	ground(x, 0xc0, 3, 8, 1, 1, SPR_MORLEVAN + 24, SPR_MORLEVAN + 24)
	x += 4
	ground(x, 0xc0, 3, 8, 1, 1, SPR_MORLEVAN + 0, SPR_MORLEVAN + 0)
	x += 4
	ground(x, 0xc0, 3, 8, 1, 1, SPR_COLON, SPR_COLON)

	x += 8
	draw_num(n, x, 0xc0, 3)
	
	x = 0x28
	ground(x, 0xc0, 3, 8, 1, 1, SPR_MORLEVAN + 72, SPR_MORLEVAN + 72)
	x += 4
	ground(x, 0xc0, 3, 8, 1, 1, SPR_MORLEVAN + 96, SPR_MORLEVAN + 96)
	x += 4
	ground(x, 0xc0, 3, 8, 1, 1, SPR_MORLEVAN + 120, SPR_MORLEVAN + 120)
	x += 4
	ground(x, 0xc0, 3, 8, 1, 1, SPR_MORLEVAN + 96, SPR_MORLEVAN + 96)
	x += 4
	ground(x, 0xc0, 3, 8, 1, 1, SPR_MORLEVAN + 72, SPR_MORLEVAN + 72)
	x += 4
	ground(x, 0xc0, 3, 8, 1, 1, SPR_COLON, SPR_COLON)
	
	x = 0x4c
	if advanced_mode:
		ground(x, 0xc0, 3, 8, 1, 1, SPR_MORLEVAN + 144, SPR_MORLEVAN + 144)
	else:
		ground(x, 0xc0, 3, 8, 1, 1, SPR_MORLEVAN + 168, SPR_MORLEVAN + 168)

func next_room_west(force: bool = false):
	if (room_num > 0):
		if (available_exits & EXIT_WEST != 0) or force:
			room_num -= 1
			player_entry_x = 0x4c
			player_entry_y = player_y
			player_x = player_entry_x
			enter_room(room_num)
	
func next_room_east(force: bool = false):
	if room_num < 127:
		if (available_exits & EXIT_EAST != 0) or force:
			room_num += 1
			player_entry_x = 0
			player_x = player_entry_x
			player_entry_y = player_y
			enter_room(room_num)
	
func next_room_south():
	var next = shamuscom[ROOM_LINK_TABLE + room_num - 0x100]
	if (next > 0) and (available_exits & EXIT_SOUTH != 0):
		room_num = next
		player_y = 0
		player_entry_y = player_y
		player_entry_x = player_x
		enter_room(room_num)

func next_room_north():
	var next = shamuscom[ROOM_LINK_TABLE + room_num - 0x100]
	if (next > 0) and (available_exits & EXIT_NORTH != 0):
		room_num = next
		player_y = 0xa4
		player_entry_y = player_y
		player_entry_x = player_x
		enter_room(room_num)

# see also compute_powerup_location
func random_spawn_loc() -> Vector2:
	var r = ((randomword & 0xf) + ((randomword >> 8) & 1)) & 0xfe # even
	
	var y = get_byte(POWERUP_POSITIONS_TABLE + r)
	var x = get_byte(POWERUP_POSITIONS_TABLE + r  + 1)
	return Vector2(x, y)

func place_monster(ah, al, index: int, kind: int, sprite: int, ofs_bx: int) -> void:
	monster_array[index].kind = kind
	var x = 0
	var y = 0
	# junction room, dance from the square in the middle
	if ah & 3 == 0:
		x = 0x22
		y = 0x40
	else:
		var xy = random_spawn_loc()
		x = xy[0]
		y = xy[1]
	#var bx = randomword & 0x1e
	y += get_byte(PLACEMENT_OFFSET + ofs_bx)
	x += get_byte(PLACEMENT_OFFSET + ofs_bx + 1)
	
	monster_array[index].y = y
	monster_array[index].x = x
	monster_array[index].sprite_ofs = 0
	monster_array[index].dir = 0
	monster_array[index].anim_ctr = 1
			
	var sprite_width = 4
	if kind == MONSTERKIND_SNAPJUMPER:
		sprite_width = 3
	
	if special_monster_flag == 0:
		movsprite(x, y, sprite_width, 8, sprite)
	else:
		xorsprite(x, y, sprite_width, 8, sprite)
	
	print("place_monster (%d,%d) kind=%d" % [x, y, kind])

func spawn_monsters(ah, al):
	update_randomword()
	
	var current_monster = 0
	# offset into PLACEMENT_OFFSET[] array, modulo 0x24?
	# 2c5d cmp bx, 0x22
	#      jle over
	#      mov bx, 0
	# increments by 2 (x,y) while placing all monsters
	var ofs_bx = randomword & 0x1e
	
	# spawn spiraldronebi
	if true:
		var n = randomword & 0xff
		if room_num > 1:
			n &= 3
			n += advanced_mode
		else:
			n = 1 + advanced_mode
		if n == 0:
			n = 1
		if room_num > 99:
			n = n + 1 + advanced_mode
			
		for i in n:
			place_monster(ah, al, current_monster, MONSTERKIND_SPIRALDRONE2, SPR_SPIRALDRONE2[0], ofs_bx)
			ofs_bx += 2
			if ofs_bx > 0x22:
				ofs_bx = 0
			current_monster += 1
			ror_randomword()
	
	# spiraldrone3
	if true:
		var n = randomword & 0x255
		if room_num > 10:
			n &= 3
		else:
			n &= 1
		n = n + 1 + advanced_mode
		if n == 0:
			n = 1

		for i in n:
			place_monster(ah, al, current_monster, MONSTERKIND_SPIRALDRONE3, SPR_SPIRALDRONE3[0], ofs_bx)
			ofs_bx += 2
			if ofs_bx > 0x22:
				ofs_bx = 0
			current_monster += 1
			ror_randomword()
		
	# robo-droids
	if room_num > 5:
		var n = al & 3 + advanced_mode
		if n == 0:
			n = 1
		for i in n:
			place_monster(ah, al, current_monster, MONSTERKIND_ROBODROID, SPR_ROBODROID[0], ofs_bx)
			ofs_bx += 2
			if ofs_bx > 0x22:
				ofs_bx = 0
			current_monster += 1
			ror_randomword()
			
	# tv sets
	if room_num > 14:
		var n = ((al & 1) + 1 + advanced_mode + (wallpat_n >> 1))
		if n == 0:
			n = 1
		if room_num > 99:
			n = n + 1 + advanced_mode
		for i in n:
			place_monster(ah, al, current_monster, MONSTERKIND_SNAPJUMPER, SPR_SNAPJUMPER[0], ofs_bx)
			ofs_bx += 2
			if ofs_bx > 0x22:
				ofs_bx = 0			
			current_monster += 1
			ror_randomword()
			
	monster_array[current_monster].kind = 0xff
	num_monsters = current_monster

func compute_powerup_location(ah, al):
	if ah & SCARY_ROOM_BIT:
		powerup_x = 0x27
		powerup_y = 0x50
	else:
		var r = ((randomword & 0xf) + ((randomword >> 8) & 1)) & 0xfe # even
		var in_BX = 0 # al & 0x1e
		while true:
			powerup_y = get_byte(POWERUP_POSITIONS_TABLE + r) + get_byte(PLACEMENT_OFFSET + in_BX)
			powerup_x = get_byte(POWERUP_POSITIONS_TABLE + r  + 1)
			if b800[get_cga_addr(powerup_x, powerup_y) + 0x191] == 0:
				break
			in_BX += 2
			if in_BX > 0x22:
				in_BX = 0
		powerup_x = powerup_x + get_byte(PLACEMENT_OFFSET + in_BX + 1)

func is_locked_room(n: int) -> bool:
	for i in LOCKED_ROOM_TABLE_SIZE:
		if get_byte(LOCKED_ROOM_TABLE + i) == n:
			return true
	return false
	
# true if keyhole
func keyhole_for_room() -> bool:
	for i in KEYHOLE_TYPE_TABLE_SIZE:
		if get_byte(KEYHOLE_TYPE_TABLE + i * 2) == room_num:
			powerup_animation_offset = get_byte(KEYHOLE_TYPE_TABLE + i * 2 + 1)
			xorsprite(powerup_x, powerup_y, SPR_KEYHOLE_W, SPR_KEYHOLE_H, SPR_KEYHOLE + powerup_animation_offset)
			return true
	return false

# place key
func key_for_room() -> bool:
	for i in KEY_LOCATIONS_TABLE_SIZE:
		if get_byte(KEY_LOCATIONS_TABLE + i * 2) == room_num:
			powerup_animation_offset = get_byte(KEY_LOCATIONS_TABLE + i * 2 + 1)
			xorsprite(powerup_x, powerup_y, SPR_KEY_W, SPR_KEY_H, SPR_KEY + powerup_animation_offset)
			return true
	return false

func place_powerup(ah, al):
	compute_powerup_location(ah, al)	# determine powerup_x, powerup_y
	powerup_kind = al & 3
	powerup_animation_offset = 0
	if powerup_kind == POWERUP_MYSTERY:
			powerup_animation_delay	= ANIMATION_SPEED_MYSTERY
			xorsprite(powerup_x, powerup_y, SPR_MYSTERY_W, SPR_MYSTERY_H, SPR_MYSTERY)
	elif powerup_kind == POWERUP_EXTRALIFE:
			powerup_animation_delay	= ANIMATION_SPEED_EXTRALIFE
			powerup_animation_offset = SPR_EXTRALIFE_F1
			xorsprite(powerup_x, powerup_y, SPR_EXTRALIFE_W, SPR_EXTRALIFE_H, SPR_EXTRALIFE)
			xorsprite(powerup_x, powerup_y + SPR_EXTRALIFE_H, SPR_EXTRALIFE_W, SPR_EXTRALIFE_H, SPR_EXTRALIFE + powerup_animation_offset)
	else:
		# if room in locked_rooms and powerup_present --> door at the side opposite of entrance
		room_locked = is_locked_room(room_num) and powerup_present
		if room_locked:
			if player_entry_x < 10:
				seal_room_right()
			else:
				seal_room_left()
			keyhole_for_room()
			powerup_kind = POWERUP_KEYHOLE
		key_for_room()

func check_powerup():
	pass

func play_sound(divider):
	if divider > 0:
		var hz = 1.1931816666e6 / divider
	pass
	
func convert_score_1():
	pass
func convert_score_2():
	pass
func convert_score_3():
	pass
	
func display_score():
	pass

func animate_powerup():
	var yofs = 11
	var height = 12
	if powerup_kind == POWERUP_KEYHOLE:
		height = 13
	
	if powerup_y < 9:
		yofs = 0x8
	
	if player_x <= powerup_x - 4 or player_x >= powerup_x + 3 or \
		player_y <= powerup_y - yofs or player_y >= powerup_y + height:
	
		if powerup_kind == POWERUP_MYSTERY:
			powerup_animation_delay -= 1
			if powerup_animation_delay == 0:
				powerup_animation_delay = ANIMATION_SPEED_MYSTERY
				xorsprite(powerup_x, powerup_y, SPR_MYSTERY_W, SPR_MYSTERY_H, SPR_MYSTERY + powerup_animation_offset)
				powerup_animation_offset = SPR_MYSTERY_F2 - powerup_animation_offset
				xorsprite(powerup_x, powerup_y, SPR_MYSTERY_W, SPR_MYSTERY_H, SPR_MYSTERY + powerup_animation_offset)
		elif powerup_kind == POWERUP_EXTRALIFE:
			powerup_animation_delay -= 1
			if powerup_animation_delay == 0:
				powerup_animation_delay = ANIMATION_SPEED_EXTRALIFE
				
				xorsprite(powerup_x, powerup_y, SPR_EXTRALIFE_W, SPR_EXTRALIFE_H, SPR_EXTRALIFE)
				xorsprite(powerup_x, powerup_y + SPR_EXTRALIFE_H, SPR_EXTRALIFE_W, SPR_EXTRALIFE_H, SPR_EXTRALIFE + powerup_animation_offset)
				
				if powerup_animation_offset == SPR_EXTRALIFE_F1:
					powerup_animation_offset = SPR_EXTRALIFE_F2
				elif powerup_animation_offset == SPR_EXTRALIFE_F2:
					powerup_animation_offset = SPR_EXTRALIFE_F3
				else:
					powerup_animation_offset = SPR_EXTRALIFE_F1
				xorsprite(powerup_x, powerup_y, SPR_EXTRALIFE_W, SPR_EXTRALIFE_H, SPR_EXTRALIFE)
				xorsprite(powerup_x, powerup_y + SPR_EXTRALIFE_H, SPR_EXTRALIFE_W, SPR_EXTRALIFE_H, SPR_EXTRALIFE + powerup_animation_offset)
	else: 
		# pickup situation
		match powerup_kind:
			POWERUP_MYSTERY:
				xorsprite(powerup_x, powerup_y, SPR_MYSTERY_W, SPR_MYSTERY_H, SPR_MYSTERY + powerup_animation_offset)
				animation_counter = 0x28
				play_sound(0x27bf) # 117 Hz
				convert_score_3()
				var ax = randomword & 0x303
				if ax >> 8 == 0:
					# extralife
					lives_remaining += 1
					draw_lives()
				if ax == 0 and time_until_shadow > 100:
					time_until_shadow = 100
				pass
			POWERUP_EXTRALIFE:
				xorsprite(powerup_x, powerup_y, SPR_EXTRALIFE_W, SPR_EXTRALIFE_H, SPR_EXTRALIFE)
				xorsprite(powerup_x, powerup_y + SPR_EXTRALIFE_H, SPR_EXTRALIFE_W, SPR_EXTRALIFE_H, SPR_EXTRALIFE + powerup_animation_offset)
				
				animation_counter = 0x28
				picked_powerup_kind = POWERUP_EXTRALIFE
				lives_remaining += 1
				draw_lives()
				play_sound(0x27bf)
				pass
			POWERUP_KEY:
				xorsprite(powerup_x, powerup_y, SPR_KEY_W, SPR_KEY_H, SPR_KEY + powerup_animation_offset)
				animation_counter = 0x20
				play_sound(0x27bf)
				for i in 3:
					if found_keys[i] == 0xff:
						found_keys[i] = powerup_animation_offset
						xorsprite(63 + i * 5, 178, SPR_KEY_W, SPR_KEY_H, SPR_KEY + powerup_animation_offset)
						break
			POWERUP_KEYHOLE:
				# translate keyhole to key
				var key = 0x60 
				var key_i = 255
				match powerup_animation_offset:
					0x00:	key = 0x00
					0x27:	key = 0x30
					0x4e:	key = 0x60
				for i in 3:
					if found_keys[i] == powerup_animation_offset:
						key_i = i
						break
				if key_i == 255:
					return # key not found
				picked_powerup_kind = POWERUP_KEYHOLE
				animation_counter = 0x18
				sliding_freq = 500
				play_sound(0x1f4) #  2386
				# clear the hole
				xorsprite(powerup_x, powerup_y, SPR_KEYHOLE_W, SPR_KEYHOLE_H, SPR_KEYHOLE + powerup_animation_offset)
				# clear the key
				xorsprite(63 + key_i * 5, 178, SPR_KEY_W, SPR_KEY_H, SPR_KEY + powerup_animation_offset)
				found_keys[key_i] = 0xff

		picked_powerup_kind = powerup_kind
		# clear powerup kind
		set_gamestate_a(room_num, get_gamestate_a(room_num) & 0xfc)
		# clear scary room flag
		set_gamestate_b(room_num, get_gamestate_b(room_num) & 0xfd)
		powerup_present = 0

func enter_room(n: int) -> void:
	update_randomword()

	special_monster_flag = 0
	powerup_present = 0
	available_exits = 0
	if advanced_mode == 0:
		time_until_shadow = (randomword & 255) + 300
	else:
		time_until_shadow = (randomword & 255) + 200

	cls()
	room_to_pattern(n)
	room_to_wallpat(n)

	var al = get_gamestate_a(n)
	var ah = get_gamestate_b(n)
	
	powerup_present = al & 3 != 0
	if powerup_present && (ah & 2 != 0):
		scary_room()

	if ah & 3 == 0:
		junction_room(ah, al)
	else:
		open_room()
	draw_inner_walls(al, ah)
	
	# seal entry and exit rooms
	if n == 0:
		seal_room_left()
	elif n == 127:
		seal_room_right()
	
	if ah & 2 == 0:	# scary room
		spawn_monsters(ah, al)
		
	if powerup_present:
		place_powerup(ah, al)

	draw_room_caption(n)
	
	xorplayer(sprite_ptr)

func animate_scary_room():
	slit_y += 1
	if slit_y > 0xb1:
		slit_y = 8
	
	var y = slit_y
	if slit_y > 0xa7:
		y = y - 10
		xground(0x1f, y, 4, 1, 1, 1, PAT4X8_VSTRIPES, PAT4X8_VSTRIPES)
		xground(0x2f, y, 4, 1, 1, 1, PAT4X8_VSTRIPES, PAT4X8_VSTRIPES)
		return
	
	xground(0x1f, y, 4, 1, 1, 1, PAT4X8_VSTRIPES, PAT4X8_VSTRIPES)
	xground(0x2f, y, 4, 1, 1, 1, PAT4X8_VSTRIPES, PAT4X8_VSTRIPES)
	
	if slit_y < 0x12:
		return

	y = y - 10
	xground(0x1f, y, 4, 1, 1, 1, PAT4X8_VSTRIPES, PAT4X8_VSTRIPES)
	xground(0x2f, y, 4, 1, 1, 1, PAT4X8_VSTRIPES, PAT4X8_VSTRIPES)

func update_randomword():
	randomword = randi() & 0xffff

func ror_randomword():
	var c = randomword & 1
	randomword >>= 1
	if c:
		randomword |= 0x8000

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if not event.echo:
				var withmods = event.get_scancode_with_modifiers()
				#print("scan=", event.scancode, "with mods=", withmods, " ctrl=", withmods & KEY_MASK_CTRL)
				if event.scancode == KEY_LEFT:
					next_room_west(withmods & KEY_MASK_CTRL != 0)
				elif event.scancode == KEY_RIGHT:
					next_room_east(withmods & KEY_MASK_CTRL != 0)
				elif event.scancode == KEY_UP:
					next_room_north()
				elif event.scancode == KEY_DOWN:
					next_room_south()
				elif event.scancode == KEY_W:
					joystick[JOY_UP] = 1
				elif event.scancode == KEY_A:
					joystick[JOY_LEFT] = 1
				elif event.scancode == KEY_D:
					joystick[JOY_RIGHT] = 1
				elif event.scancode == KEY_S:
					joystick[JOY_DOWN] = 1
		else:
			if event.scancode == KEY_W:
				joystick[JOY_UP] = 0
			elif event.scancode == KEY_A:
				joystick[JOY_LEFT] = 0
			elif event.scancode == KEY_D:
				joystick[JOY_RIGHT] = 0
			elif event.scancode == KEY_S:
				joystick[JOY_DOWN] = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	b800 = PoolByteArray()
	b800.resize(320*200/4)
	truecolor = PoolByteArray()
	truecolor.resize(320*200*4)
	intarray.resize(320 * 200)
	update_randomword()
	cls()
	updateTexture()
	load_data()
	
	room_num = 0 #18 #37
	player_x = 2
	player_y = 0x5c
	player_entry_x = player_x
	player_entry_y = player_y
	sprite_ptr = SPR_SHAMUS[0]
	lives_remaining = 5
	found_keys = [255, 255, 255]
	#found_keys = [0x0, 0x30, 0x60]
	
	for i in 26:
		monster_array.append(foe_data.new())

	# seems to be reasonably close to the original game
	Engine.set_target_fps(50/3)

	enter_room(room_num)
