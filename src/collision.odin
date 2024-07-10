package src

import "core:log"
import "core:math"
import "core:math/linalg"
import rl "libs:raylib"

resolve_circle_rect_collision :: proc(
	center: Vector,
	r: f32,
	rect: rl.Rectangle,
	rot_deg: f32,
) -> Vector {
	cos := math.cos(-math.RAD_PER_DEG * rot_deg)
	sin := math.sin(-math.RAD_PER_DEG * rot_deg)

	relative := Vector {
		cos * (center.x - rect.x) - sin * (center.y - rect.y),
		sin * (center.x - rect.x) + cos * (center.y - rect.y),
	}

	half_width := rect.width / 2
	half_height := rect.height / 2

	closest := Vector {
		clamp(relative.x, -half_width, half_width),
		clamp(relative.y, -half_height, half_height),
	}

	x_part := math.abs(closest.x) / half_width
	y_part := math.abs(closest.y) / half_height

	diff := x_part - y_part

	normal := linalg.normalize0(
		Vector{diff > -0.01 ? math.sign(closest.x) : 0, diff < 0.01 ? math.sign(closest.y) : 0},
	)

	normal = normal.x == 0 && normal.y == 0 ? {0, 1} : normal

	penetration_x := max(r + half_width - math.abs(relative.x), 0)
	penetration_y := max(r + half_height - math.abs(relative.y), 0)

	return {
		(cos * normal.x * penetration_x + sin * normal.y * penetration_y),
		(-sin * normal.x * penetration_x + cos * normal.y * penetration_y),
	}
}

resolve_line_rect_colision :: proc(a, b: Vector, rect: rl.Rectangle, rot_deg: f32) -> Vector {
	cos := math.cos(-math.RAD_PER_DEG * rot_deg)
	sin := math.sin(-math.RAD_PER_DEG * rot_deg)

	relative_a := Vector {
		cos * (a.x - rect.x) - sin * (a.y - rect.y),
		sin * (a.x - rect.x) + cos * (a.y - rect.y),
	}

	relative_b := Vector {
		cos * (b.x - rect.x) - sin * (b.y - rect.y),
		sin * (b.x - rect.x) + cos * (b.y - rect.y),
	}

	half_width := rect.width / 2
	half_height := rect.height / 2

	delta := relative_b - relative_a

	if delta.x == 0 && (relative_a.x < -half_width || relative_a.x > half_width) {
		return {0, 0}
	}

	if delta.y == 0 && (relative_a.y < -half_height || relative_a.y > half_height) {
		return {0, 0}
	}

	x_dir := math.sign(delta.x)
	y_dir := math.sign(delta.y)

	closest_x := delta.x == 0 ? math.inf_f32(-1) : (-x_dir * half_width - relative_a.x) / delta.x
	farest_x := delta.x == 0 ? math.inf_f32(1) : (x_dir * half_width - relative_a.x) / delta.x

	closest_y := delta.y == 0 ? math.inf_f32(-1) : (-y_dir * half_height - relative_a.y) / delta.y
	farest_y := delta.y == 0 ? math.inf_f32(1) : (y_dir * half_height - relative_a.y) / delta.y

	if (closest_x > farest_y || closest_y > farest_x) {
		return {0, 0}
	}

	last_closest := math.max(closest_x, closest_y)
	first_farest := math.min(farest_x, farest_y)

	if (last_closest > 1 || first_farest < 0) {
		return {0, 0}
	}

	relative := Vector {
		relative_a.x + last_closest * delta.x,
		relative_a.y + last_closest * delta.y,
	}

	return {
		(cos * relative.x + sin * relative.y) + rect.x,
		(-sin * relative.x + cos * relative.y) + rect.y,
	}
}
