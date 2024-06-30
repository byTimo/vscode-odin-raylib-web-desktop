# vscode Odin+Raylib dekstop/web starter

Welcome to the Odin+Raylib starter template for VS Code! This project template is designed to help you develop games for both desktop and web platforms using Odin and Raylib in VS Code.

> Note: This template is primarily configured for macOS. If you’re using a different operating system, you’ll need to adjust the debug configuration accordingly.

## Features

- __Desktop Debug Configuration__: Build and debug the game on the desktop using [CodeLLDB](https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb).
- __Web Debug Configuration__: Manages [Live server](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer) running/shutdown and project prebuilding.

## Prerequisite

Before you begin, make sure you have the following installed:

- [Odin](https://odin-lang.org/docs/install/)
- [Emscripten](https://emscripten.org/docs/getting_started/downloads.html)

- [Live Server VSCode extention](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer)
- [CodeLLDB VSCode extention](https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb)

## Project Structure

The main game code is written in the root of the repository. The entry point is the `main.odin` file within the game package. There are also two additional subpackages: `web` and `desktop`, which handle platform-specific execution.

The `libs` folder holds all additional libraries required for the project. These libraries should be specified in the Emscripten targets in the Makefile.

The `assets` folder stores all game assets. If assets are located elsewhere, their paths must be provided to Emscripten in the `Makefile`.

## Game Structure

Due to Emscripten limitations, the game module must include the following three procedures:

1. `init`: Initializes the game, including the window.
2. `update`: Called continuously during the game loop to update game logic.
3. `dispose`: Cleans up resources before the game terminates (primarily used in the desktop subpackage).

## Credits

- [Puzzle Texture](https://kenney.nl/assets/puzzle-pack) by kenney.nl
- Web setup inspired by [Caedo](https://github.com/Caedo/raylib_wasm_odin) and [atomicptr](https://github.com/atomicptr/odin-raylib-web-starter)

## Lincese

This project is licensed under the MIT License. See the LICENSE file for more details.
