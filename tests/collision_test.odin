package tests

import "../src"
import "core:testing"
import rl "libs:raylib"

@(test)
no :: proc(t: ^testing.T) {
	using src

	pos := Vector{4, 20}
	r := f32(5)
	rect := rl.Rectangle{20, 20, 20, 20}
	rot_deg := f32(0)

	exp_penetraion := Vector{0, 0}

	act_penetration := resolve_circle_rect_collision(pos, r, rect, rot_deg)

	testing.expect_value(t, act_penetration, exp_penetraion)
}

@(test)
left_side_one_point :: proc(t: ^testing.T) {
	using src

	pos := Vector{5, 20}
	r := f32(5)
	rect := rl.Rectangle{20, 20, 20, 20}
	rot_deg := f32(0)

	exp_penetraion := Vector{0, 0}

	act_penetration := resolve_circle_rect_collision(pos, r, rect, rot_deg)

	testing.expect_value(t, act_penetration, exp_penetraion)
}

@(test)
left_side_circle_center_on_border :: proc(t: ^testing.T) {
	using src

	pos := Vector{10, 20}
	r := f32(5)
	rect := rl.Rectangle{20, 20, 20, 20}
	rot_deg := f32(0)

	exp_penetraion := Vector{-5, 0}

	act_penetration := resolve_circle_rect_collision(pos, r, rect, rot_deg)

	testing.expect_value(t, act_penetration, exp_penetraion)
}

@(test)
left_side_center_inside :: proc(t: ^testing.T) {
	using src

	pos := Vector{15, 18}
	r := f32(5)
	rect := rl.Rectangle{20, 20, 20, 20}
	rot_deg := f32(0)

	exp_penetraion := Vector{-10, 0}

	act_penetration := resolve_circle_rect_collision(pos, r, rect, rot_deg)

	testing.expect_value(t, act_penetration, exp_penetraion)
}

@(test)
centers_equal :: proc(t: ^testing.T) {
	using src

	pos := Vector{20, 20}
	r := f32(5)
	rect := rl.Rectangle{20, 20, 20, 20}
	rot_deg := f32(0)

	exp_penetraion := Vector{0, 15}

	act_penetration := resolve_circle_rect_collision(pos, r, rect, rot_deg)

	testing.expect_value(t, act_penetration, exp_penetraion)
}

@(test)
simple_collision_with_angle :: proc(t: ^testing.T) {
	using src

	pos := Vector{17, 20}
	r := f32(5)
	rect := rl.Rectangle{20, 20, 20, 20}
	rot_deg := f32(90)

	exp_penetraion := Vector{-12, 0}

	act_penetration := resolve_circle_rect_collision(pos, r, rect, rot_deg)

	testing.expectf(
		t,
		abs(act_penetration.x - exp_penetraion.x) < 0.01,
		"Expected X %v, got %v",
		exp_penetraion.x,
		act_penetration.x,
	)
	testing.expectf(
		t,
		abs(act_penetration.y - exp_penetraion.y) < 0.01,
		"Expected Y %v, got %v",
		exp_penetraion.x,
		act_penetration.x,
	)
}


@(test)
line_rect__left_side_short :: proc(t: ^testing.T) {
	using src

	a := Vector{0, 10}
	b := Vector{5, 10}
	rect := rl.Rectangle{20, 20, 20, 20}
	rot_deg := f32(0)

	exp_point := Vector{0, 0}

	act_point := resolve_line_rect_colision(a, b, rect, rot_deg)

	testing.expect_value(t, act_point, exp_point)
}

@(test)
line_rect__left_side_collision_on_end:: proc(t: ^testing.T) {
	using src

	a := Vector{0, 10}
	b := Vector{10, 10}
	rect := rl.Rectangle{20, 20, 20, 20}
	rot_deg := f32(0)

	exp_point := Vector{10, 10}

	act_point := resolve_line_rect_colision(a, b, rect, rot_deg)

	testing.expect_value(t, act_point, exp_point)
}

@(test)
line_rect__collision_on_left_border:: proc(t: ^testing.T) {
	using src

	a := Vector{0, 10}
	b := Vector{15, 10}
	rect := rl.Rectangle{20, 20, 20, 20}
	rot_deg := f32(0)

	exp_point := Vector{10, 10}

	act_point := resolve_line_rect_colision(a, b, rect, rot_deg)

	testing.expect_value(t, act_point, exp_point)
}

@(test)
line_rect__collision_on_top_border:: proc(t: ^testing.T) {
	using src

	a := Vector{13, 0}
	b := Vector{13, 40}
	rect := rl.Rectangle{20, 20, 20, 20}
	rot_deg := f32(0)

	exp_point := Vector{13, 10}

	act_point := resolve_line_rect_colision(a, b, rect, rot_deg)

	testing.expect_value(t, act_point, exp_point)
}

@(test)
line_rect__collision_on_top_left_corner:: proc(t: ^testing.T) {
	using src

	a := Vector{20, 0}
	b := Vector{0, 20}
	rect := rl.Rectangle{20, 20, 20, 20}
	rot_deg := f32(0)

	exp_point := Vector{10, 10}

	act_point := resolve_line_rect_colision(a, b, rect, rot_deg)

	testing.expect_value(t, act_point, exp_point)
}

@(test)
line_rect__collision_in_top_middle :: proc(t: ^testing.T) {
	using src

	a := Vector{25, 0}
	b := Vector{5, 20}
	rect := rl.Rectangle{20, 20, 20, 20}
	rot_deg := f32(0)

	exp_point := Vector{15, 10}

	act_point := resolve_line_rect_colision(a, b, rect, rot_deg)

	testing.expect_value(t, act_point, exp_point)
}

@(test)
line_rect__collision_y_line_left_of_rect :: proc(t: ^testing.T) {
	using src

	a := Vector{5, 0}
	b := Vector{5, 20}
	rect := rl.Rectangle{20, 20, 20, 20}
	rot_deg := f32(0)

	exp_point := Vector{0, 0}

	act_point := resolve_line_rect_colision(a, b, rect, rot_deg)

	testing.expect_value(t, act_point, exp_point)
}

@(test)
line_rect__collision_x_line_bottom_of_rect :: proc(t: ^testing.T) {
	using src

	a := Vector{5, 40}
	b := Vector{45, 40}
	rect := rl.Rectangle{20, 20, 20, 20}
	rot_deg := f32(0)

	exp_point := Vector{0, 0}

	act_point := resolve_line_rect_colision(a, b, rect, rot_deg)

	testing.expect_value(t, act_point, exp_point)
}