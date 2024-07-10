PACKAGE := game

STACK_SIZE := 1048576
HEAP_SIZE := 67108864

test:
	rm -rf out/tests
	mkdir -p out/tests
	odin test tests/ -all-packages --collection:libs=libs -out:"out/tests/t.bin" -define:ODIN_TEST_THREADS=1

build-desktop:
	rm -rf out/debug/desktop
	mkdir -p out/debug/desktop
	odin build desktop --collection:libs=libs -out:"out/debug/desktop/${PACKAGE}" -debug

build-web:
	rm -rf out/debug/web
	rm -rf out/debug/.intermediate
	mkdir -p out/debug/web
	mkdir -p out/debug/.intermediate
	odin build web --collection:libs=libs -target=freestanding_wasm32 -out:"out/debug/.intermediate/$(PACKAGE)" -build-mode:obj -debug -show-system-calls
	emcc -o out/debug/web/index.html web/web.c out/debug/.intermediate/$(PACKAGE).wasm.o libs/raylib/web/libraylib.a -sUSE_GLFW=3 -sGL_ENABLE_GET_PROC_ADDRESS -DWEB_BUILD -sSTACK_SIZE=$(STACK_SIZE) -sTOTAL_MEMORY=$(HEAP_SIZE) -sERROR_ON_UNDEFINED_SYMBOLS=0 --preload-file assets

build-web-release:
	rm -rf out/release/web
	rm -rf out/release/.intermediate
	mkdir -p out/release/web
	mkdir -p out/release/.intermediate
	odin build web --collection:libs=libs -target=freestanding_wasm32 -out:"out/release/.intermediate/$(PACKAGE)" -build-mode:obj -o:size
	emcc -o out/release/web/index.html web/web.c out/release/.intermediate/$(PACKAGE).wasm.o libs/raylib/web/libraylib.a -sUSE_GLFW=3 -sGL_ENABLE_GET_PROC_ADDRESS -DWEB_BUILD -sSTACK_SIZE=$(STACK_SIZE) -sTOTAL_MEMORY=$(HEAP_SIZE) -sERROR_ON_UNDEFINED_SYMBOLS=0 --preload-file assets