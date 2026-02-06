# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

NetHack Falcon's Eye 1.9.3 is an enhanced graphical window port for NetHack 3.3.1. It adds isometric 256-color graphics, sound effects, MIDI music, and a mouse-driven interface while preserving the original NetHack gameplay. The codebase targets multiple platforms: Unix/Linux, DOS (DJGPP), Windows, BeOS, and Emscripten/WebAssembly.

## Build Commands

### Unix/Linux Native Build
```bash
# Full build (compiles game, utilities, data files)
make all

# Build just the game binary
make

# Install to ./compiled directory
make install

# Clean object files
make clean

# Full clean (removes executables and data)
make spotless
```

### Emscripten/WebAssembly Build
```bash
# From project root, first build native to generate data files
make all

# Then build for web (from build-web directory)
cd build-web
make -f ../sys/emscripten/Makefile.em
```

### DOS Build (DJGPP)
Requires Allegro 4 library. Follow instructions in `sys/msdos/Install.dos`.

## Architecture

### Directory Structure
- `src/` - Core NetHack game logic (~100 C files)
- `include/` - Header files including `config.h` (main configuration)
- `win/jtp/` - Falcon's Eye graphics interface (the main window system)
- `win/tty/` - Terminal interface (alternative to JTP)
- `sys/unix/` - Unix-specific code and entry point (`unixmain.c`)
- `sys/emscripten/` - WebAssembly build configuration
- `sys/share/` - Shared system code (TTY, I/O control)
- `dat/` - Game data files (dungeons, levels, text)
- `util/` - Build utilities (`dgn_comp`, `lev_comp`, `dlb`)

### Graphics Stack (win/jtp/)
The Falcon's Eye window system uses a layered architecture:

1. **jtp_win.c** - Main window manager, display logic, game UI (largest file at ~300KB)
2. **jtp_gra.c** - Graphics abstraction layer
3. **jtp_sdl.c** - SDL2 backend (primary for Unix/Emscripten)
4. **jtp_keys.c** - Keyboard input handling and command mapping
5. **jtp_mou.c** - Mouse input and autopilot system
6. **winjtp.c** - NetHack window interface adapter

Platform-specific graphics backends:
- `jtp_sdl.c` - SDL2 (Linux, Emscripten)
- `jtp_dirx.c` - DirectX (Windows)
- `jtp_dos.c` - DOS direct access

### Key Configuration
- `include/config.h` lines 17-70: OS detection and window system selection
- `JTP_GRAPHICS` define enables Falcon's Eye for each platform
- `DEFAULT_WINDOW_SYS "jtp"` makes JTP the default
- `USE_SDL_SYSCALLS` flag enables SDL2 rendering

### Game Assets
Located in `win/jtp/gamedata/`:
- `config/` - Key mappings (`jtp_keys.txt`), options, sound config
- `graphics/` - PCX isometric tiles (42 files)
- `sound/` - MIDI music and WAV sound effects
- `manual/` - HTML game documentation

### Build Utilities (util/)
These are compiled first and used to generate game data:
- `dgn_comp` - Dungeon description compiler
- `lev_comp` - Level compiler
- `dlb` - Data library builder (packs game files)
- `makedefs` - Generates various header files and data

### Entry Point Flow
```
sys/unix/unixmain.c::main()
  → choose_windows("jtp")    // Select window system
  → jtp_init_nhwindows()     // Initialize graphics (winjtp.c)
  → moveloop()               // Main game loop (src/allmain.c)
```

## Platform Conditional Compilation

Key defines in config.h:
- `UNIX` - Unix/Linux builds
- `MSDOS` - DOS builds
- `WIN32` - Windows builds
- `__EMSCRIPTEN__` - WebAssembly builds (excludes TTY_GRAPHICS)
- `__BEOS__` - BeOS builds

For Emscripten, the build uses:
- `-s USE_SDL=2` and `-s USE_SDL_MIXER=2` for audio/graphics
- `-s ASYNCIFY` for async operation support
- 64MB initial memory with growth enabled
