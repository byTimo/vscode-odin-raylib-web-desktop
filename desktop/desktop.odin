package desktop

import "../src"
import rl "libs:raylib"

main :: proc() {
    using src
    
    init()
    for !rl.WindowShouldClose() {
        update()
    }
    dispose()
}