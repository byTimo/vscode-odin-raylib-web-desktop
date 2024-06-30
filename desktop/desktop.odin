package desktop

import g ".."
import rl "libs:raylib"

main :: proc() {
    g.init()
    for !rl.WindowShouldClose() {
        g.update()
    }
    g.dispose()
}