package web

import "../src"
import "base:runtime"
import "core:math/rand"
import "core:mem"
import rl "libs:raylib"

foreign import "odin_env"

ctx: runtime.Context

tempAllocatorData: [mem.Megabyte * 4]byte
tempAllocatorArena: mem.Arena

mainMemoryData: [mem.Megabyte * 16]byte
mainMemoryArena: mem.Arena

@(export, link_name = "game_init")
game_init :: proc "c" () {
	using src

	ctx = runtime.default_context()
	context = ctx

	mem.arena_init(&mainMemoryArena, mainMemoryData[:])
	mem.arena_init(&tempAllocatorArena, tempAllocatorData[:])

	ctx.allocator = mem.arena_allocator(&mainMemoryArena)
	ctx.temp_allocator = mem.arena_allocator(&tempAllocatorArena)
	init()
}

@(export, link_name = "game_update")
game_update :: proc "contextless" () {
	using src
	context = ctx
	update()
}

@(export, link_name = "game_dispose")
game_dispose :: proc "contextless" () {
	using src
	context = ctx
	dispose()
}
