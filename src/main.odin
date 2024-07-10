package src

import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:mem"
import rl "libs:raylib"

IS_WEB :: ODIN_ARCH == .wasm32 || ODIN_ARCH == .wasm64p32

SCREEN_NAME :: "circle-box"
SCREEN_WIDTH :: 16 * 50
SCREEN_HEIGHT :: 16 * 50

WORLD_WIDTH :: 16 * 20
WORLD_HEIGHT :: 16 * 20

CIRCLE_SPEED_S: f32 : 400

RECT_ROTATION_SPEED_S: f32 : 45

PX_TO_UNIT_RATIO :: f32(10) / 32
LOGIC_FRAME_RATE :: f32(1) / 30

BACKGROUND_COLOR :: rl.Color{71, 91, 141, 255}

Vector :: rl.Vector2

RECT_NORMALS :: [4]Vector{{0, 1}, {0, -1}, {1, 0}, {-1, 0}}

// TODO (andrei) one day I will have to read about `using`

Circle :: struct {
	pos:        Vector,
	dir:        Vector,
	r:          f32,
	target_pos: Vector,
	prev_pos:   Vector,
}

Rect :: struct {
	rect:            rl.Rectangle,
	origin:          Vector,
	rotation:        f32,
	target_rotation: f32,
	prev_rotation:   f32,
}

Game :: struct {
	a_pos:       Vector,
	b_pos:       Vector,
	col_pos:     Vector,
	pen_pos:     Vector,
	debug:       map[string]cstring,
	camera:      rl.Camera2D,
	main:        Circle,
	rect:        Rect,
	logic_delta: f32,
	logic_alpha: f32,
}

when !IS_WEB {
	track: mem.Tracking_Allocator
}

@(private = "file")
game: Game

init :: proc() {
	when ODIN_DEBUG && !IS_WEB {
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)
	}

	rl.SetConfigFlags({.VSYNC_HINT, .WINDOW_RESIZABLE})
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_NAME)

	game = {
		camera = rl.Camera2D{},
		main = {pos = {WORLD_WIDTH / 2, WORLD_HEIGHT / 2}, r = 10},
		rect = {rect = rl.Rectangle{20, 20, 20, 20}, origin = {20 / 2, 20 / 2}, rotation = 0},
		logic_delta = LOGIC_FRAME_RATE,
		a_pos = {0, 0},
		b_pos = {40, 40},
	}
}

update :: proc() {
	frame_delta := rl.GetFrameTime()
	game.logic_delta += frame_delta

	window_width := f32(rl.GetScreenWidth())
	window_height := f32(rl.GetScreenHeight())
	game.camera.zoom = min(window_width / WORLD_WIDTH, window_height / WORLD_HEIGHT)
	game.camera.offset = {window_width / 2, window_height / 2}

	for game.logic_delta >= LOGIC_FRAME_RATE {
		game.logic_delta -= LOGIC_FRAME_RATE

		game.main.prev_pos = game.main.pos
		game.rect.prev_rotation = game.rect.rotation

		mouse_pos := rl.GetScreenToWorld2D(rl.GetMousePosition(), game.camera)
		if (linalg.distance(mouse_pos, game.main.pos) <= CIRCLE_SPEED_S * LOGIC_FRAME_RATE) {
			game.main.dir = {0, 0}
			game.main.target_pos = mouse_pos
		} else {
			game.main.dir = linalg.normalize0(mouse_pos - game.main.pos)
			game.main.target_pos =
				game.main.pos + game.main.dir * CIRCLE_SPEED_S * LOGIC_FRAME_RATE

		}
		game.rect.target_rotation = game.rect.rotation + RECT_ROTATION_SPEED_S * LOGIC_FRAME_RATE

		penetration := resolve_circle_rect_collision(
			game.main.target_pos,
			game.main.r,
			game.rect.rect,
			game.rect.target_rotation,
		)

		game.pen_pos = game.main.target_pos
		if (penetration.x != 0 || penetration.y != 0) {
			game.main.target_pos += penetration
		}

		if rl.IsMouseButtonDown(.LEFT) {
			game.b_pos = mouse_pos
		}

		if rl.IsMouseButtonDown(.RIGHT) {
			game.a_pos = mouse_pos
		}

		game.col_pos = resolve_line_rect_colision(game.a_pos, game.b_pos, game.rect.rect, game.rect.target_rotation)
	}

	game.logic_alpha = game.logic_delta / LOGIC_FRAME_RATE

	game.main.pos = math.lerp(game.main.prev_pos, game.main.target_pos, game.logic_alpha)
	game.rect.rotation = math.lerp(
		game.rect.prev_rotation,
		game.rect.target_rotation,
		game.logic_alpha,
	)

	cos := math.cos(math.to_radians_f32(-game.rect.rotation))
	sin := math.sin(math.to_radians_f32(-game.rect.rotation))

	relative_point := Vector {
		cos * (game.main.pos.x - game.rect.rect.x) - sin * (game.main.pos.y - game.rect.rect.y),
		sin * (game.main.pos.x - game.rect.rect.x) + cos * (game.main.pos.y - game.rect.rect.y),
	}

	diff := Vector {
		math.clamp(relative_point.x, -game.rect.rect.width / 2, game.rect.rect.width / 2),
		math.clamp(relative_point.y, -game.rect.rect.height / 2, game.rect.rect.height / 2),
	}

	diff2 := Vector{cos * diff.x + sin * diff.y, -sin * diff.x + cos * diff.y}

	rl.BeginDrawing()
	rl.BeginMode2D(game.camera)
	rl.ClearBackground(BACKGROUND_COLOR)

	rl.DrawRectanglePro(game.rect.rect, game.rect.origin, 0, rl.GRAY)
	rl.DrawRectanglePro(game.rect.rect, game.rect.origin, game.rect.rotation, rl.GREEN)
	rl.DrawCircleV(game.pen_pos, game.main.r, rl.RED)
	rl.DrawCircleV(game.main.pos, game.main.r, rl.WHITE)

	rl.DrawLineEx(game.a_pos, game.b_pos, 2, rl.BLUE)
	if game.col_pos.x != 0 || game.col_pos.y != 0 {
		rl.DrawLineEx(game.a_pos, game.col_pos, 2, rl.GOLD)
	}

	rl.DrawCircleV(relative_point + Vector{game.rect.rect.x, game.rect.rect.y}, 2, rl.BLUE)
	rl.DrawCircleV(diff + Vector{game.rect.rect.x, game.rect.rect.y}, 2, rl.RED)
	rl.DrawCircleV(diff2 + Vector{game.rect.rect.x, game.rect.rect.y}, 2, rl.ORANGE)

	rl.EndMode2D()

	idx := 0
	for _, value in game.debug {
		rl.DrawText(value, 5, i32(idx * 21), 20, rl.WHITE)
		idx += 1
	}

	rl.EndDrawing()
}

dispose :: proc() {
	rl.CloseWindow()

	when ODIN_DEBUG && !IS_WEB {
		if len(track.allocation_map) > 0 {
			fmt.printf("=== %v allocations not freed: ===\n", len(track.allocation_map))
			for _, entry in track.allocation_map {
				fmt.printf("- %v bytes @ %v\n", entry.size, entry.location)
			}
		}
		if len(track.bad_free_array) > 0 {
			fmt.printf("=== %v incorrect frees: ===\n", len(track.bad_free_array))
			for entry in track.bad_free_array {
				fmt.printf("- %p @ %v\n", entry.memory, entry.location)
			}
		}
		mem.tracking_allocator_destroy(&track)
	}
}


draw_debug :: proc(state: ^Game, name: string, value: any) {
	prev, ok := state.debug[name]
	if ok {
		delete(prev)
	}
	state.debug[name] = fmt.caprintf("%v: %v", name, value)
}
