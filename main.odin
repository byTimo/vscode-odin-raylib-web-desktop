package game

import rl "libs:raylib"

BLOCK :: "assets/element_green_rectangle.png"

texture: rl.Texture2D

init :: proc() {
	rl.InitWindow(200, 200, "Game")
	texture = rl.LoadTexture(BLOCK)
}

update :: proc() {
	rl.BeginDrawing()
	rl.DrawTexture(texture, 100, 100, rl.WHITE)
	rl.EndDrawing()
}

dispose :: proc() {
	rl.UnloadTexture(texture)
}
